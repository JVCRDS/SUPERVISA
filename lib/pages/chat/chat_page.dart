import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Controla se está na tela inicial ou na tela de resposta
  bool _mostrandoResposta = false;
  String _perguntaSelecionada = '';
  String _respostaSelecionada = '';

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
    setState(() {
      _mostrandoResposta = true;
      _perguntaSelecionada = _perguntasFrequentes[index]['pergunta']!;
      _respostaSelecionada = _perguntasFrequentes[index]['resposta']!;
    });
  }

  void _voltarParaGrid() {
    setState(() {
      _mostrandoResposta = false;
      _perguntaSelecionada = '';
      _respostaSelecionada = '';
    });
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
          onPressed: _mostrandoResposta ? _voltarParaGrid : () => Navigator.pop(context),
        ),
      ),
      body: _mostrandoResposta ? _buildTelaResposta() : _buildTelaInicial(),
    );
  }

  // TELA INICIAL COM GRID DE PERGUNTAS
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
          Container(
            height: 3,
            width: 60,
            color: Colors.blue[800],
          ),
          const SizedBox(height: 20),

          // Instrução
          Text(
            'Toque ou digite sua dúvida para continuar.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 30),

          // Grid de perguntas - FIXEI O OVERFLOW AQUI
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12, // Reduzi o espaçamento
              mainAxisSpacing: 12,
              childAspectRatio: 1.1, // Ajuste para melhor proporção
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
                color: Colors.green[700],
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

  // CARD DE PERGUNTA - CORRIGIDO OVERFLOW
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
          padding: const EdgeInsets.all(10),
          height: 140, // Altura fixa para consistência
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ÍCONE
              Image.asset(
                caminhoIcone,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              // TEXTO COM SCROLL VERTICAL
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    pergunta,
                    style: TextStyle(
                      fontSize: 12,
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

  // TELA DE RESPOSTA - AGORA COM SCROLL
  Widget _buildTelaResposta() {
    return Column(
      children: [
        // Área de conteúdo com scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pergunta do usuário
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/Chat_icon.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _perguntaSelecionada,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Resposta do assistente - AGORA PODE SER LONGA
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/Supervisa_Icon.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _respostaSelecionada,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Área fixa inferior (botões)
        Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
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

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _voltarParaGrid,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.grey[800],
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Ver mais perguntas'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
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
                      child: const Text('Voltar ao menu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}