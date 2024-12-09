import 'package:dsi_app/src/repositories/ollama_repository.dart';

class OllamaController {
  Stream<String>? generateResponse(String prompt) {
    return OllamaRepository.generateResponse(prompt);
  }
}
