import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/forgot_password/forgot_password.dart';
import 'package:flutter_application_1/pages/main_menu/main_menu.dart';
import 'package:flutter_application_1/pages/register/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo centralizada
            _buildLogo(),
            const SizedBox(height: 40),
            
            // Campos de login
            _buildLoginForm(
              context,
              emailController,
              passwordController,
            ),
            
            // Botões de ação
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/icons/Supervisa_Logo.png',
          height: 300,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    final blueColor = Colors.blue.shade700;

    return Column(
      children: [
        TextField(
          controller: emailController,
          cursorColor: blueColor, // Cor do cursor azul
          decoration: InputDecoration(
            labelText: 'E-mail',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueColor, width: 2.0),
            ),
            prefixIcon: Icon(Icons.email, color: blueColor),
            labelStyle: TextStyle(color: blueColor),
            floatingLabelStyle: TextStyle(color: blueColor), // Label quando sobe
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          cursorColor: blueColor, // Cor do cursor azul
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Senha',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueColor, width: 2.0),
            ),
            prefixIcon: Icon(Icons.lock, color: blueColor),
            labelStyle: TextStyle(color: blueColor),
            floatingLabelStyle: TextStyle(color: blueColor), // Label quando sobe
          ),
        ),
        const SizedBox(height: 8),
        
        // Esqueci senha abaixo do campo de senha em vermelho
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              );
            },
            child: const Text(
              'Esqueci minha senha',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Botão Entrar
        _buildLoginButton(context, emailController, passwordController),
      ],
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleLogin(context, emailController, passwordController),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Entrar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.blue.shade700),
              foregroundColor: Colors.blue.shade700,
            ),
            child: const Text(
              'Cadastrar-se',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validação dos campos
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha email e senha!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Tenta fazer login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Login bem-sucedido - navega para o menu principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainMenuPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Tratamento específico de erros do Firebase
      String errorMessage = 'Erro ao fazer login';
      
      if (e.code == 'user-not-found') {
        errorMessage = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email inválido';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      logger.e('Login error: $e');
    } catch (e) {
      // Erro genérico
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
      logger.e('Unexpected error: $e');
    }
  }
}