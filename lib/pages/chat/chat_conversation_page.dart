import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/firestore_service.dart';

class ChatConversationPage extends StatefulWidget {
  final String perguntaInicial;
  final String respostaInicial;

  const ChatConversationPage({
    super.key,
    required this.perguntaInicial,
    required this.respostaInicial,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final List<Map<String, dynamic>> _mensagens = [];
  final TextEditingController _textController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Adiciona a primeira pergunta e resposta
    _mensagens.add({
      'texto': widget.perguntaInicial,
      'isUser': true,
      'timestamp': DateTime.now(),
    });
    _mensagens.add({
      'texto': widget.respostaInicial,
      'isUser': false,
      'timestamp': DateTime.now().add(const Duration(seconds: 1)),
    });

    _salvarPerguntaNoFirestore(
      widget.perguntaInicial,
      widget.respostaInicial,
    );
  }

  
  void _salvarPerguntaNoFirestore(String pergunta, String resposta) {
    if (_currentUser != null) {
      _firestoreService.saveQuestion(
        userId: _currentUser!.uid,
        userEmail: _currentUser!.email ?? 'Não informado',
        userName: 'Usuário', // Você pode pegar do Firestore depois
        question: pergunta,
        answer: resposta,
        topic: _identificarTopico(pergunta),
      );
    }
  }

  // ✅ IDENTIFICAR TÓPICO DA PERGUNTA
  String _identificarTopico(String pergunta) {
    final perguntaLower = pergunta.toLowerCase();
    
    if (perguntaLower.contains('dengue') || perguntaLower.contains('mosquito')) {
      return 'Dengue';
    } else if (perguntaLower.contains('escorpião') || perguntaLower.contains('picada')) {
      return 'Escorpião';
    } else if (perguntaLower.contains('restaurante') || perguntaLower.contains('norma')) {
      return 'Restaurante';
    } else if (perguntaLower.contains('terreno') || perguntaLower.contains('plantar')) {
      return 'Terreno Baldio';
    } else {
      return 'Geral';
    }
  }

  void _enviarMensagem(String texto) {
    if (texto.trim().isEmpty) return;

    setState(() {
      _mensagens.add({
        'texto': texto,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    _textController.clear();

    // Simular resposta do bot após 1 segundo
    Future.delayed(const Duration(seconds: 1), () {
      final resposta = _gerarResposta(texto);
      
      setState(() {
        _mensagens.add({
          'texto': resposta,
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });

 
      _salvarPerguntaNoFirestore(texto, resposta);
    });
  }

  String _gerarResposta(String pergunta) {
    final perguntaLower = pergunta.toLowerCase();
    
    if (perguntaLower.contains('dengue') || perguntaLower.contains('prevenção') || perguntaLower.contains('mosquito')) {
      return 'Para prevenir a dengue, é importante eliminar criadouros do mosquito. Elimine água parada, use repelente e mantenha caixas d\'água fechadas. Em caso de sintomas, procure uma unidade de saúde.';
    } else if (perguntaLower.contains('escorpião') || perguntaLower.contains('picada')) {
      return 'Ao encontrar escorpiões, não tente capturar. Chame a Divisão de Vigilância Ambiental. Em caso de picada, procure IMEDIATAMENTE atendimento médico.';
    } else if (perguntaLower.contains('restaurante') || perguntaLower.contains('norma') || perguntaLower.contains('higiene')) {
      return 'Para restaurantes, é necessário seguir as normas de higiene e segurança alimentar. Mantenha funcionários treinados, controle de temperatura e higienização adequada.';
    } else if (perguntaLower.contains('terreno') || perguntaLower.contains('plantar') || perguntaLower.contains('baldio')) {
      return 'Para plantar em terrenos baldios, é necessário autorização da prefeitura e concordância do proprietário. Consulte a Secretaria do Meio Ambiente.';
    } else if (perguntaLower.contains('contato') || perguntaLower.contains('telefone') || perguntaLower.contains('email')) {
      return 'Você pode entrar em contato com a Divisão de Vigilância Ambiental:\nNORTE: (16) 3638-0562\nSUL: (16) 3914-3431\nLESTE: (16) 3624-7234\nOESTE: (16) 3630-7844\nCENTRAL: (16) 3610-4740';
    } else {
      return 'Obrigado pela sua pergunta! Para questões específicas sobre vigilância em saúde, entre em contato com a Divisão de Vigilância Ambiental ou consulte nosso suporte técnico.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icons/Supervisa_Logo.png',
          height: 300,
          width: 1000,
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Área das mensagens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              reverse: false,
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[index];
                return _buildMensagemBubble(mensagem);
              },
            ),
          ),

          // Área de digitação
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _enviarMensagem,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue[800],
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _enviarMensagem(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensagemBubble(Map<String, dynamic> mensagem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mensagem['isUser'])
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/icons/Supervisa_Icon.png'),
              radius: 16,
            ),
          if (!mensagem['isUser']) const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: mensagem['isUser'] 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                Card(
                  color: mensagem['isUser'] 
                      ? Colors.blue[50] 
                      : Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      mensagem['texto'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatarHora(mensagem['timestamp']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (mensagem['isUser']) const SizedBox(width: 8),
          if (mensagem['isUser'])
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  String _formatarHora(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}