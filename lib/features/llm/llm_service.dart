import 'package:movie_chat/features/llm/models/llm_response.dart';

abstract class LLMService {
  Future<LLMResponse> prompt(String prompt);
}

class LLMResponseException implements Exception {
  LLMResponseException(this.message, this.exception);

  final String message;
  final Exception exception;
}
