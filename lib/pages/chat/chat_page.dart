import 'package:flutter/material.dart';
import 'chat_conversation_page.dart'; 

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Lista de perguntas frequentes
  final List<Map<String, String>> _perguntasFrequentes = [
    {
      'pergunta': 'Como prevenir a dengue?',
      'resposta': 'Para prevenir a dengue:\n\n• Elimine água parada em vasos, pneus e garrafas\n• Use repelente regularmente\n• Coloque telas em janelas e portas\n• Mantenha caixas d\'água fechadas\n• Limpe calhas regularmente\n\nEm caso de sintomas como febre alta, dor no corpo e manchas vermelhas, procure uma unidade de saúde.'
    },
    {
      'pergunta': 'Encontrei um escorpião. O que fazer?',
      'resposta': 'Ao encontrar um escorpião:\n\n• Afaste-se e não tente capturar\n• Mantenha o local fechado se possível\n• Chame a Divisão de Vigilância Ambiental em Saúde:\nNORTE: (16) 3638-0562\nSUL:(16) 3914-3431\nLESTE:(16) 3624 7234\nOESTE:(16) 3630-7844\nCENTRAL:(16) 3610-4740\n• Evite acumulo de entulhos e lixo\n• Use telas em ralos e vedação em portas\n\nEm caso de picada, procure IMEDIATAMENTE o serviço de saúde mais próximo.'
    },
    {
      'pergunta': 'Posso plantar em terrenos baldios?',
      'resposta': 'Sobre plantar em terrenos baldios:\n\n• É necessário autorização da prefeitura\n• Verifique a legislação municipal\n• Terrenos particulares precisam da concordância do proprietário\n• Considere questões de segurança e saneamento\n\nEntre em contato com a Secretaria do Meio Ambiente para orientações específicas.'
    },
    {
      'pergunta': 'Como manter meu restaurante dentro das normas?',
      'resposta': 'Normas sanitárias para restaurantes:\n\n• Mantenha funcionários com uniforme limpo e higienizado\n• Controle de temperatura de alimentos\n• Higienização adequada de utensílios\n• Armazenamento correto de produtos\n• Controle de pragas regular\n• Manipuladores com curso de boas práticas\n\nAgende uma vistoria com a Vigilância Sanitária municipal. O protocolo de documentos deverá ser feito PREFERENCIALMENTE  por meio da Prefeitura Sem Papel no Portal de Atendimento https://processodigital.ribeiraopreto.sp.gov.br/atendimento/inicio/ ou presencialmente no órgão da Prefeitura no Poupatempo.'
    },
  ];

  void _mostrarResposta(int index) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationPage(
          perguntaInicial: _perguntasFrequentes[index]['pergunta']!,
          respostaInicial: _perguntasFrequentes[index]['resposta']!,
        ),
      ),
    );
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
      body: _buildTelaInicial(),
    );
  }

  Widget _buildTelaInicial() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Center(
            child: Image.asset(
              'assets/icons/Supervisa_Icon.png',
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              height: 3,
              width: 60,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),

          // Instrução
          Center(
            child: Text(
              'Toque em sua dúvida para continuar.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Grid de perguntas
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: _perguntasFrequentes.length,
            itemBuilder: (context, index) {
              return _buildCardPergunta(index);
            },
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),

          Center(
            child: Text(
              'Suporte para Vigilância em Saúde',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue[700],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Botão Voltar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Voltar para o menu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCardPergunta(int index) {
    final Map<String, String> icones = {
      'Como prevenir a dengue?': 'assets/icons/Icon_Doença.png',
      'Encontrei um escorpião. O que fazer?': 'assets/icons/Icon_Escorpião.png',
      'Posso plantar em terrenos baldios?': 'assets/icons/Icon_Planta.png',
      'Como manter meu restaurante dentro das normas?': 'assets/icons/Icon_Restaurante.png',
    };

    final pergunta = _perguntasFrequentes[index]['pergunta']!;
    final caminhoIcone = icones[pergunta] ?? 'assets/icons/Chat_icon.png';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _mostrarResposta(index), 
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16), 
          height: 160, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                caminhoIcone,
                width: 48, 
                height: 48, 
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
          
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    pergunta,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}