import 'package:movie_chat/features/account/feedback_api.dart';
import 'package:movie_chat/features/account/feedback_store.dart';

class FeedbackRepository {
  FeedbackRepository({required this.feedbackApi, required this.feedbackStore});

  final FeedbackApi feedbackApi;
  final FeedbackStore feedbackStore;

  Future<void> submitFeedback(String comment) async {
    try {
      final token = await feedbackApi.sendFeedback(comment);
      await feedbackStore.saveToken(token);
    } catch (e) {
      throw Exception(
        'Error al enviar comentarios. Por favor, intenta nuevamente.',
      );
    }
  }

  Future<String?> getSavedToken() async {
    return await feedbackStore.getToken();
  }

  Future<void> clearToken() async {
    await feedbackStore.deleteToken();
  }
}
