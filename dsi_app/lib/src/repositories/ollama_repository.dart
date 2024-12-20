import 'package:dsi_app/src/services/http_service.dart';

class OllamaRepository {
  static Stream<String>? generateResponse(String prompt) async* {
    Map body = {
      'model': 'llama3',
      'prompt': prompt,
    };

    yield* HttpService.postStream(
      url: 'http://10.34.129.121:8080/api/generate',
      body: body,
    );
  }
}
