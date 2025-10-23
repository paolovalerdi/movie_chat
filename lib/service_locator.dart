import 'package:get_it/get_it.dart';
import 'package:movie_chat/features/chat/chat_repository.dart';
import 'package:movie_chat/features/chat/chat_store.dart';
import 'package:movie_chat/features/llm/gemini_llm_service.dart';
import 'package:movie_chat/router/screens/chat/chat_state_holder.dart';
import 'package:sembast/sembast_memory.dart';

final locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  locator.registerSingleton<Database>(await openNewInMemoryDatabase());

  locator.registerFactory<ChatStore>(() => ChatStore(db: locator<Database>()));

  locator.registerFactory<ChatRepository>(
    () => ChatRepository(
      chatStore: locator<ChatStore>(),
      llmServices: GeminiLLMService(),
    ),
  );

  // Chat screen
  locator.registerFactory<ChatStateHolder>(
    () => ChatStateHolder(repository: locator<ChatRepository>()),
  );
}
