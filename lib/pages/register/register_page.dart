import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/login/login_page.dart';
import '/services/firestore_service.dart'; 

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    
    final FirestoreService firestoreService = FirestoreService(); 

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título centralizado
            _buildTitle(),
            const SizedBox(height: 40),
            
            
            _buildRegisterForm(
              context,
              emailController,
              passwordController,
              confirmPasswordController,
              phoneController,
              nameController, 
              firestoreService, 
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
    TextEditingController nameController, 
    FirestoreService firestoreService, 
  ) {
    final blueColor = Colors.blue.shade700;

    return Column( 
      children: [
        TextField(
          controller: nameController,
          cursorColor: blueColor,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Nome Completo',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueColor, width: 2.0),
            ),
            prefixIcon: Icon(Icons.person, color: blueColor),
            labelStyle: TextStyle(color: blueColor),
            floatingLabelStyle: TextStyle(color: blueColor),
          ),
        ),
        const SizedBox(height: 16),
        
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
          nameController, 
          firestoreService, 
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
    TextEditingController nameController,
    FirestoreService firestoreService, 
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
          nameController, 
          firestoreService,
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
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanedPhone.length < 10 || cleanedPhone.length > 11) {
      return false;
    }
    
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
    TextEditingController nameController, 
    FirestoreService firestoreService, 
  ) async {
    final name = nameController.text.trim(); 
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();

    
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_validarTelefone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um telefone válido com DDD!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
   
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await firestoreService.saveUser(
          userId: userCredential.user!.uid,
          name: name,
          email: email,
          password: password,
          pcd: false,
          phone: phone, 
        );
      }

    
      final telefoneFormatado = _formatarTelefone(phone);

   
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta criada com sucesso!\nNome: $name\nTelefone: $telefoneFormatado'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );

    
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });

    } on FirebaseAuthException catch (e) {
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