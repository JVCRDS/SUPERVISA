import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icons/Supervisa_Logo.png',
          height: 275, 
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título
            _buildTitle(),
            const SizedBox(height: 40),
            
            // Campos do formulário
            _buildForgotPasswordForm(context, emailController),
            
            // Botões de ação
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Icon(
          Icons.lock_reset,
          size: 60,
          color: Colors.blue,
        ),
        SizedBox(height: 16),
        Text(
          'RECUPERAR SENHA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Digite seu email para redefinir sua senha',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm(
    BuildContext context,
    TextEditingController emailController,
  ) {
    final blueColor = Colors.blue.shade700;

    return Column(
      children: [        
        TextField(
          controller: emailController,
          cursorColor: blueColor,
          keyboardType: TextInputType.emailAddress,
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
            floatingLabelStyle: TextStyle(color: blueColor),
          ),
        ),
        const SizedBox(height: 24),
        
        // Botão Enviar
        _buildSendButton(context, emailController),
      ],
    );
  }

  Widget _buildSendButton(
    BuildContext context,
    TextEditingController emailController,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handlePasswordReset(context, emailController),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Enviar Link de Recuperação',
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
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.blue.shade700),
              foregroundColor: Colors.blue.shade700,
            ),
            child: const Text(
              'Voltar para Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePasswordReset(
    BuildContext context,
    TextEditingController emailController,
  ) async {
    final email = emailController.text.trim();

    // Validação do campo
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu email!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      // Sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de recuperação enviado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Volta para o login após 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });

    } on FirebaseAuthException catch (e) {
      // Tratamento específico de erros do Firebase
      String errorMessage = 'Erro ao enviar email de recuperação';
      
      if (e.code == 'user-not-found') {
        errorMessage = 'Email não encontrado';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email inválido';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Erro de conexão. Verifique sua internet';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      logger.e('Password reset error: $e');
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