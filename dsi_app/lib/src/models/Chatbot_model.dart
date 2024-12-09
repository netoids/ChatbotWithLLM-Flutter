// ignore_for_file: prefer_final_fields

// Enum para controlar os 'tipos de pessoas' possíveis de se ter no chatbot
enum ChatbotTipoPessoa {
  user,
  ia;
}

class ChatbotMessageModel {
  ChatbotMessageModel.usuario(this.question) : tipoPessoa = ChatbotTipoPessoa.user;
  ChatbotMessageModel.ia() : tipoPessoa = ChatbotTipoPessoa.ia;

  final ChatbotTipoPessoa tipoPessoa;
  String? question; //Quando a mensagem for da IA, question será null

  // Armazena as respostas da IA em uma lista
  List<IAResponseModel> _iaResponses = [];

  // Getter para verificar se a mensagem é do usuário
  bool get isUser => tipoPessoa == ChatbotTipoPessoa.user;

  // Obtém o texto completo gerado pela a IA
  String get fullIaResponseText {
    return _iaResponses.map((e) => e.response).join('');
  }

  // Verifica se a IA já parou de responder
  bool get iaResponseDone {
    return _iaResponses.any((e) => e.isDone);
  }

  // Adiciona uma nova resposta da IA
  void addIAResponse(IAResponseModel response) {
    _iaResponses.add(response);
  }
}

// Classe model para as respostas da IA
class IAResponseModel {
  IAResponseModel.fromWeb(Map data) {
    response = data['response'];
    isDone = data['done'];
  }

  late final String response;
  late final bool isDone;
}
