import 'package:movie_chat/features/chat/models/chat_message.dart';
import 'package:sembast/sembast_memory.dart';

class ChatStore {
  ChatStore({required Database db}) : _db = db;

  final Database _db;

  final _store = intMapStoreFactory.store("chat_messages");

  Stream<List<ChatMessage>> stream() {
    final query = _store.query(
      finder: Finder(sortOrders: [SortOrder('timestamp', true)]),
    );

    return query.onSnapshots(_db).map((snapshot) {
      return List.unmodifiable(
        snapshot.map((record) {
          return ChatMessage.fromJson(record.value);
        }),
      );
    });
  }

  Future<void> saveMessage(ChatMessage message) {
    return _db.transaction((tx) async {
      await _store.add(tx, message.toJson());
    });
  }
}
