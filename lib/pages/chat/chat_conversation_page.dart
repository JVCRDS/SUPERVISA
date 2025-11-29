import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/genkit_service.dart';
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
  late GenKitService _genkitService;
  final FirestoreService _firestoreService = FirestoreService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    _genkitService = GenKitService(
      userId: _currentUser?.uid ?? 'anonimo',
    );

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _salvarPerguntaNoFirestore(String pergunta, String resposta) {
  if (_currentUser != null) {
    _firestoreService.saveQuestion(
      userId: _currentUser.uid,
      userEmail: _currentUser.email ?? 'Não informado',
      userName: _currentUser.displayName ?? 'Usuário',
      question: pergunta,
      answer: resposta,
      topic: _identificarTopico(pergunta),
    );
  }
}

  String _identificarTopico(String pergunta) {
    final perguntaLower = pergunta.toLowerCase();
    
    if (perguntaLower.contains('dengue') || perguntaLower.contains('mosquito')) {
      return 'Dengue';
    } else if (perguntaLower.contains('escorpião') || perguntaLower.contains('picada')) {
      return 'Escorpião';
    } else if (perguntaLower.contains('restaurante') || perguntaLower.contains('norma') || perguntaLower.contains('higiene')) {
      return 'Restaurante';
    } else if (perguntaLower.contains('terreno') || perguntaLower.contains('plantar') || perguntaLower.contains('baldio')) {
      return 'Terreno Baldio';
    } else if (perguntaLower.contains('contato') || perguntaLower.contains('telefone') || perguntaLower.contains('email')) {
      return 'Contato';
    } else {
      return 'Geral';
    }
  }

  void _enviarMensagem(String texto) async {
    if (texto.trim().isEmpty) return;

    setState(() {
      _mensagens.add({
        'texto': texto,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      final resposta = await _genkitService.gerarRespostaComContexto(texto);
      
      setState(() {
        _isTyping = false;
        _mensagens.add({
          'texto': resposta,
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });

      _salvarPerguntaNoFirestore(texto, resposta);
      _scrollToBottom();

    } catch (e) {
      setState(() {
        _isTyping = false;
        _mensagens.add({
          'texto': 'Desculpe, estou com problemas técnicos no momento. '
                   'Por favor, tente novamente ou entre em contato com a Zoonoses.',
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
      print('Error in chat: $e');
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _mensagens.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _mensagens.length) {
                  return _buildTypingIndicator();
                }
                final mensagem = _mensagens[index];
                return _buildMensagemBubble(mensagem);
              },
            ),
          ),

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
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSubmitted: _enviarMensagem,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue[800],
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
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

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.health_and_safety, color: Colors.blue),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Card(
            color: Colors.blue[50],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Digitando',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensagemBubble(Map<String, dynamic> mensagem) {
    final isUser = mensagem['isUser'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.health_and_safety, color: Colors.blue),
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Card(
                  color: isUser ? Colors.blue[50] : Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      mensagem['texto'],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.grey[800],
                      ),
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
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  String _formatarHora(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}