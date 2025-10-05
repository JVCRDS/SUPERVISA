import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/login/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título centralizado
            _buildTitle(),
            const SizedBox(height: 40),
            
            // Campos de cadastro
            _buildRegisterForm(
              context,
              emailController,
              passwordController,
              confirmPasswordController,
              phoneController,
            ),
            
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
        Text(
          'CADASTRO',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Crie sua conta',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    TextEditingController phoneController,
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
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          cursorColor: blueColor,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Telefone',
            hintText: '(11) 99999-9999',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueColor, width: 2.0),
            ),
            prefixIcon: Icon(Icons.phone, color: blueColor),
            labelStyle: TextStyle(color: blueColor),
            floatingLabelStyle: TextStyle(color: blueColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          cursorColor: blueColor,
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
            floatingLabelStyle: TextStyle(color: blueColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          cursorColor: blueColor,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirmar Senha',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueColor, width: 2.0),
            ),
            prefixIcon: Icon(Icons.lock_outline, color: blueColor),
            labelStyle: TextStyle(color: blueColor),
            floatingLabelStyle: TextStyle(color: blueColor),
          ),
        ),
        const SizedBox(height: 24),
        
        // Botão Cadastrar
        _buildRegisterButton(
          context, 
          emailController, 
          passwordController, 
          confirmPasswordController,
          phoneController,
        ),
      ],
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    TextEditingController phoneController,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleRegister(
          context, 
          emailController, 
          passwordController, 
          confirmPasswordController,
          phoneController,
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Cadastrar',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.blue.shade700),
              foregroundColor: Colors.blue.shade700,
            ),
            child: const Text(
              'Voltar ao Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Função para validar telefone
  bool _validarTelefone(String phone) {
    // Remove caracteres não numéricos
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Verifica se tem entre 10 e 11 dígitos (com DDD)
    if (cleanedPhone.length < 10 || cleanedPhone.length > 11) {
      return false;
    }
    
    // Verifica se começa com DDD válido (2 dígitos)
    final ddd = int.tryParse(cleanedPhone.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return false;
    }
    
    return true;
  }

  // Função para formatar telefone
  String _formatarTelefone(String phone) {
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanedPhone.length == 11) {
      return '(${cleanedPhone.substring(0, 2)}) ${cleanedPhone.substring(2, 7)}-${cleanedPhone.substring(7)}';
    } else if (cleanedPhone.length == 10) {
      return '(${cleanedPhone.substring(0, 2)}) ${cleanedPhone.substring(2, 6)}-${cleanedPhone.substring(6)}';
    }
    
    return phone;
  }

  Future<void> _handleRegister(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    TextEditingController phoneController,
  ) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();

    // Validação dos campos
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica se o telefone é válido
    if (!_validarTelefone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um telefone válido com DDD!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica se as senhas coincidem
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica o comprimento da senha
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 6 caracteres!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Tenta criar o usuário
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Formata o telefone para exibição
      final telefoneFormatado = _formatarTelefone(phone);

      // Sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta criada com sucesso!\nTelefone: $telefoneFormatado'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );

      // Volta para o login após 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });

    } on FirebaseAuthException catch (e) {
      // Tratamento específico de erros do Firebase
      String errorMessage = 'Erro ao criar conta';
      
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Este email já está em uso';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email inválido';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Senha muito fraca';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Operação não permitida';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      logger.e('Register error: $e');
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