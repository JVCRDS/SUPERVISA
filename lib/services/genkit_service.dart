import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenKitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late GenerativeModel _model;
  final String _userId;

  GenKitService({String? userId}) : _userId = userId ?? 'anonimo' {
    _initializeModel(); // ✅ CHAMANDO NO CONSTRUTOR
  }

  void _initializeModel() {
    const String apiKey = 'AIzaSyDXkAV8oPX-Sas8v3vhcUK9s97xCSHgp78';
    
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    print('✅ IA Inicializada para usuário: $_userId');
  }

  Future<String> gerarRespostaComContexto(String pergunta) async {
    print('🔄 CHAMANDO IA - Pergunta: "$pergunta"');
    
    try {
      // ✅ BUSCA HISTÓRICO COM FILTRO COMPLETO
      final historico = await _buscarHistoricoComFiltro();
      
      final prompt = '''
VOCÊ É: Um atendente humano da Secretaria da Saúde de Ribeirão Preto.

MEMÓRIA DA CONVERSA (últimas mensagens):
$historico

INFORMAÇÕES OFICIAIS (use quando relevante):

• DENGUE: Elimine água parada. Use repelente. Coloque telas. Procure saúde se tiver sintomas.

• ESCORPIÃO: Não tente capturar. Telefones: NORTE: (16) 3638-0562 | SUL: (16) 3914-3431 | LESTE: (16) 3624-7234 | OESTE: (16) 3630-7844 | CENTRAL: (16) 3610-4740. Picada = procure saúde IMEDIATAMENTE.

• TERRENOS: Precisa de autorização da prefeitura.

• RESTAURANTES: Mantenha higiene. Controle temperatura. Agende vistoria.

INSTRUÇÕES IMPORTANTES:
- Use a memória da conversa para entender o contexto
- Se a pessoa perguntar "oq eu disse?" ou "entendeu?", consulte o histórico
- Mantenha a conversa fluida e natural
- Seja empático e útil
- Para escorpiões em casa: oriente a ligar para a Zoonoses

NOVA PERGUNTA: "$pergunta"

RESPOSTA NATURAL (considere o histórico):
''';

      print('📤 Enviando para IA...');
      final response = await _model.generateContent([Content.text(prompt)]);
      
      String resposta = response.text ?? _respostaPadrao(pergunta);
      print('📥 Resposta: $resposta');
      
      await _salvarInteracao(pergunta, resposta);
      return resposta;

    } catch (e) {
      print('💥 ERRO NA IA: $e');
      return _respostaPadrao(pergunta);
    }
  }

  // ✅ BUSCA HISTÓRICO COM FILTRO COMPLETO
  Future<String> _buscarHistoricoComFiltro() async {
    try {
      final snapshot = await _firestore.collection('questions')
          .where('userId', isEqualTo: _userId)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      if (snapshot.docs.isEmpty) {
        return 'Primeira interação - sem histórico anterior.';
      }

      final buffer = StringBuffer();
      buffer.writeln('HISTÓRICO RECENTE:');
      
      final historicoOrdenado = snapshot.docs.reversed.toList();
      
      for (final doc in historicoOrdenado) {
        final data = doc.data();
        buffer.writeln('Usuário: ${data['question']}');
        buffer.writeln('Atendente: ${data['answer']}');
        buffer.writeln('---');
      }

      return buffer.toString();
    } catch (e) {
      print('❌ Erro ao buscar histórico: $e');
      return 'Sem histórico disponível no momento.';
    }
  }

  Future<void> _salvarInteracao(String pergunta, String resposta) async {
    try {
      await _firestore.collection('questions').add({
        'userId': _userId,
        'question': pergunta,
        'answer': resposta,
        'timestamp': FieldValue.serverTimestamp(),
        'topic': _identificarTopico(pergunta),
      });
      print('💾 Salvo no Firestore para usuário: $_userId');
    } catch (e) {
      print('❌ Erro ao salvar: $e');
    }
  }

  String _identificarTopico(String pergunta) {
    final perguntaLower = pergunta.toLowerCase();
    if (perguntaLower.contains('dengue')) return 'Dengue';
    if (perguntaLower.contains('escorpião')) return 'Escorpião';
    if (perguntaLower.contains('restaurante')) return 'Restaurante';
    if (perguntaLower.contains('terreno')) return 'Terreno Baldio';
    return 'Geral';
  }

  String _respostaPadrao(String pergunta) {
    return 'Olá! Em que posso ajudar você hoje? Pode me perguntar sobre dengue, escorpiões ou outros assuntos de saúde.';
  }
}