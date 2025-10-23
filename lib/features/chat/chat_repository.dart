import 'package:movie_chat/features/chat/chat_store.dart';
import 'package:movie_chat/features/chat/models/chat_message.dart';
import 'package:movie_chat/features/llm/llm_service.dart';

class ChatRepository {
  ChatRepository({required this.llmServices, required this.chatStore});

  final LLMService llmServices;

  final ChatStore chatStore;

  Stream<List<ChatMessage>> streamMessages() {
    return chatStore.stream();
  }

  Future<void> sendMessage(String message) async {
    try {
      chatStore.saveMessage(
        ChatMessage(
          content: message,
          role: ChatMessageRole.user,
          timestamp: DateTime.now(),
        ),
      );

      final response = await llmServices.prompt(message);

      chatStore.saveMessage(
        ChatMessage(
          content: response.text,
          role: ChatMessageRole.llm,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      throw Exception('Error al enviar mensaje');
    }
  }
}
