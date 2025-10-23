import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_chat/features/chat/chat_repository.dart';
import 'package:movie_chat/features/chat/chat_store.dart';
import 'package:movie_chat/features/feedback/feedback_api.dart';
import 'package:movie_chat/features/feedback/feedback_repository.dart';
import 'package:movie_chat/features/feedback/feedback_store.dart';
import 'package:movie_chat/features/llm/gemini_llm_service.dart';
import 'package:movie_chat/features/watchlist/omdb_api.dart';
import 'package:movie_chat/features/watchlist/watchlist_store.dart';
import 'package:movie_chat/router/screens/account/feedback_state_holder.dart';
import 'package:movie_chat/router/screens/chat/chat_state_holder.dart';
import 'package:movie_chat/router/screens/watchlist/watchlist_state_holder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

final locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  final dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  final dbPath = "${dir.path}/app.db";
  final db = await databaseFactoryIo.openDatabase(dbPath);

  locator.registerSingleton<Database>(db);
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Chat
  locator.registerFactory<ChatStore>(() => ChatStore(db: locator<Database>()));
  locator.registerFactory<ChatRepository>(
    () => ChatRepository(
      chatStore: locator<ChatStore>(),
      llmServices: GeminiLLMService(),
    ),
  );
  locator.registerFactory<ChatStateHolder>(
    () => ChatStateHolder(repository: locator<ChatRepository>()),
  );

  // Watchlist
  locator.registerFactory<WatchlistStore>(
    () => WatchlistStore(db: locator<Database>()),
  );
  locator.registerFactory<OMDBApi>(() => OMDBApi());
  locator.registerFactory<WatchlistStateHolder>(
    () => WatchlistStateHolder(
      store: locator<WatchlistStore>(),
      api: locator<OMDBApi>(),
    ),
  );

  // Feedback
  locator.registerFactory<FeedbackApi>(() => FeedbackApi());
  locator.registerFactory<FeedbackStore>(
    () => FeedbackStore(storage: locator<FlutterSecureStorage>()),
  );
  locator.registerFactory<FeedbackRepository>(
    () => FeedbackRepository(
      feedbackApi: locator<FeedbackApi>(),
      feedbackStore: locator<FeedbackStore>(),
    ),
  );
  locator.registerFactory<FeedbackStateHolder>(
    () => FeedbackStateHolder(repository: locator<FeedbackRepository>()),
  );
}
