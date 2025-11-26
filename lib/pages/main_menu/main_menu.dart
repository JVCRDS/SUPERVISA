import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/about/about_page.dart';
import 'package:flutter_application_1/pages/login/login_page.dart';
import 'package:flutter_application_1/pages/chat/chat_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão 1: Sobre o app
                  _buildMenuButton(
                    iconPath: 'assets/icons/Icon_Sobre.png',
                    title: 'Sobre o app',
                    subtitle: 'Conheça o SUPERVISA',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
                    },
                  ),
                  
                  const SizedBox(height: 40), 
                  
                  // Botão 2: Falar com o Assistente
                  _buildMenuButton(
                    iconPath: 'assets/icons/Chat_icon.png',
                    title: 'Falar com Assistente',
                    subtitle: 'Tirar dúvidas com o chat',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
                    },
                  ),
                ],
              ),
            ),
            
            // Botão Sair do app
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _sairDoApp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 18, 53, 100),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.exit_to_app, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sair do app',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        elevation: 4,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                iconPath,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue[800],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _sairDoApp(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      
      // Volta para a tela de login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      
    } catch (e) {
      // Se der erro, ainda tenta voltar para o login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }
}