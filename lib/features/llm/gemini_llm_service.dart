import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_chat/features/llm/llm_service.dart';
import 'package:movie_chat/features/llm/models/llm_response.dart';

String _composePrompt(String userPrompt) {
  return """
You're part of chatbot application that has vast knowledge about movies. You should answer to the <prompt> tag with one of the following features, it should be the one that is closer to the user intention.:
- Give the user watch recommendations
- Fun facts and other curiosities about movies
- Keep answers shorts
- Limited Information about actors, directors, etc
- Only If possible, return valid links to images that can be human verifiable, at most 3 images if the links are broken don't include them

Some limitations:
- Anwser in Spanish
- If the <prompt> of the user contains a request for something outside of the movie topic you should try to return the user to the topic or deny answering politely.
- Always keep a respectful tone, not too formal.
- Keep the responses as short chat-like messages
- Only response in plain text

<prompt>
$userPrompt
</prompt>
""";
}

class GeminiLLMService implements LLMService {
  static final String _apiKey = dotenv.get("GEMINI_API_KEY", fallback: "");

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-lite-latest:generateContent';

  @override
  Future<LLMResponse> prompt(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'x-goog-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': _composePrompt(prompt)},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return _parseGeminiResponse(responseData);
      } else {
        throw LLMResponseException(
          'Ocurrio un error al generar la respuesta',
          Exception('HTTP ${response.statusCode}: ${response.body}'),
        );
      }
    } catch (e) {
      throw LLMResponseException(
        'Ocurrio un error al generar la respuesta usando Gemini',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  LLMResponse _parseGeminiResponse(Map<String, dynamic> responseData) {
    try {
      // Navigate through the Gemini API response structure
      final candidates = responseData['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('Ocurrió un error');
      }

      final candidate = candidates[0] as Map<String, dynamic>;
      final content = candidate['content'] as Map<String, dynamic>?;
      if (content == null) {
        throw Exception('Ocurrió un error');
      }

      final parts = content['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw Exception('Ocurrió un error');
      }

      final part = parts[0] as Map<String, dynamic>;
      final text = part['text'] as String?;
      if (text == null) {
        throw Exception('Ocurrió un error');
      }

      return LLMResponse(text: text, imageUrls: []);
    } catch (e) {
      throw LLMResponseException(
        'Ocurrió un error al generar la respuesta. Intenta nuevamente',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
