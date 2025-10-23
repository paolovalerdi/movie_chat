import 'dart:math';

import 'package:movie_chat/features/llm/llm_service.dart';
import 'package:movie_chat/features/llm/models/llm_response.dart';

class DummyLLMService implements LLMService {
  final random = Random();

  DummyLLMService();

  @override
  Future<LLMResponse> prompt(String prompt) async {
    final index = random.nextInt(_messages.length);

    return Future.delayed(Duration(seconds: 2), () => _messages[index]);
  }
}

final _messages = [
  LLMResponse(
    text:
        '¿Sabías que "El Padrino" es considerada una de las mejores películas de la historia? Fue dirigida por Francis Ford Coppola y ganó tres premios Óscar, incluyendo Mejor Película en 1973. La actuación de Marlon Brando y la música de Nino Rota son legendarias.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'Te recomiendo ver “Parásitos”, una aclamada película coreana dirigida por Bong Joon-ho. Ganó el Óscar a Mejor Película en 2020, convirtiéndose en la primera cinta de habla no inglesa en lograrlo. Su trama mezcla comedia negra y drama social de manera magistral.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'Penélope Cruz es una destacada actriz española reconocida por su versatilidad. Ganó el Óscar por su papel en "Vicky Cristina Barcelona" y ha trabajado en exitosos filmes como "Volver" y "Todo sobre mi madre", colaborando frecuentemente con Pedro Almodóvar.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'Steven Spielberg, considerado uno de los cineastas más influyentes de todos los tiempos, dirigió “Jurassic Park” en 1993. Esta película revolucionó los efectos visuales y la animación digital, y estableció un estándar para el cine de ciencia ficción y aventuras.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'La trilogía de “El Señor de los Anillos”, dirigida por Peter Jackson, es imperdible para los amantes de la fantasía épica. Basada en la obra de J.R.R. Tolkien, la saga ganó 17 premios Óscar en total, destacando su impresionante mundo visual y narrativa profunda.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'Leonardo DiCaprio ganó el Óscar a Mejor Actor por su intensa actuación en “El renacido” (The Revenant) en 2016. Antes de este logro, fue nominado varias veces por filmes como "El Lobo de Wall Street" y "Titanic", consolidando su prestigio en Hollywood.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        '“Coco” es una emotiva película animada de Pixar inspirada en la festividad mexicana del Día de Muertos. Ganó los premios Óscar a Mejor Película Animada y Mejor Canción Original, y destaca por su colorido, banda sonora y bonito mensaje sobre la importancia de la familia.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'El personaje de Harry Potter fue interpretado por el actor británico Daniel Radcliffe en la saga de ocho películas basada en los libros de J.K. Rowling. La franquicia es una de las más exitosas de la historia y ha dejado una gran huella en la cultura popular.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        '“Roma”, dirigida por Alfonso Cuarón, es una obra maestra del cine mexicano galardonada con tres premios Óscar, incluyendo Mejor Película Extranjera. Retrata la vida en la Ciudad de México en los años 70 y fue aclamada por su fotografía y narrativa personal.',
    imageUrls: [],
  ),
  LLMResponse(
    text:
        'Marvel Studios ha producido más de 20 películas interconectadas en el Universo Cinematográfico de Marvel (MCU). Películas como “Avengers: Endgame” se han convertido en algunas de las más taquilleras de la historia, popularizando a superhéroes como Iron Man y Capitán América.',
    imageUrls: [],
  ),
];
