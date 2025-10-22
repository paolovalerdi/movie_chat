import 'dart:math';

import 'package:movie_chat/features/llm/llm_service.dart';
import 'package:movie_chat/features/llm/models/llm_response.dart';

class DummyLLMService implements LLMService {
  final random = Random();

  DummyLLMService();

  @override
  Future<LLMResponse> prompt(String prompt) async {
    final index = random.nextInt(_messages.length);

    return Future.delayed(Duration(milliseconds: 500), () => _messages[index]);
  }
}

final _messages = [
  LLMResponse(
    text: '¿Sabías que El Padrino ganó tres premios Óscar?',
    imageUrls: [],
  ),
  LLMResponse(
    text: 'Te recomiendo ver “Parásitos”, una excelente película coreana.',
    imageUrls: [],
  ),
  LLMResponse(
    text: 'Penélope Cruz es una reconocida actriz española.',
    imageUrls: [],
  ),
  LLMResponse(text: 'Steven Spielberg dirigió Jurassic Park.', imageUrls: []),
  LLMResponse(
    text: 'La trilogía de El Señor de los Anillos es imperdible.',
    imageUrls: [],
  ),
  LLMResponse(
    text: 'Leonardo DiCaprio ganó el Óscar por “El renacido”.',
    imageUrls: [],
  ),
  LLMResponse(
    text: '“Coco” es una emotiva película animada sobre la familia.',
    imageUrls: [],
  ),
  LLMResponse(
    text: 'El personaje de Harry Potter es interpretado por Daniel Radcliffe.',
    imageUrls: [],
  ),
  LLMResponse(
    text: 'Roma, de Alfonso Cuarón, ganó el Óscar a mejor película extranjera.',
    imageUrls: [],
  ),
  LLMResponse(
    text: 'Marvel Studios ha producido más de 20 películas.',
    imageUrls: [],
  ),
];
