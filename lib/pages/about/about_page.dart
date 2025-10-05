import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            
            Center(
              child: Container(
                height: 3,
                width: 60,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 30),

            // Subtítulo
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/Icon_Sobre.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sobre o aplicativo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Primeiro parágrafo
            Text(
              'O SUPERVISA é um aplicativo desenvolvido para ampliar o acesso da população de Ribeirão Preto às informações e serviços da Secretaria Municipal da Saúde. Surgiu da necessidade de fortalecer a comunicação entre os cidadãos e os setores de vigilância em saúde, promovendo mais agilidade, transparência e acolhimento.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),

            // Segundo parágrafo
            Text(
              'Com uma interface simples e intuitiva, o SUPERVISA foi pensado para facilitar o acompanhamento de ações, tirar dúvidas e aproximar o cuidado da realidade de cada cidadão.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            // Versão
            Center(
              child: Text(
                'v0.0.1',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Text(
                'João Vitor Candido Ribeiro e Cauan Eduardo Cunha',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),


            // Divisor
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),

            // Slogan
            Center(
              child: Text(
                'Suporte para Vigilância em Saúde',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Botão Voltar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
      ),
    );
  }
}