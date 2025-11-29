import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser({
    required String userId,
    required String name,
    required String email,
    required String password,
    required bool pcd,
    required String phone,
  }) async {
    try {
      await _db.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'pcd': pcd,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('User saved in Firestore: $email');
    } catch (e) {
      print('ERROR: não foi possível salvar usuário no Firestore: $e');
      throw e;
    }
  }

 
  Future<void> saveQuestion({
    required String userId,
    required String userEmail,
    required String userName,
    required String question,
    required String answer,
    required String topic,
  }) async {
    try {
      await _db.collection('questions').add({
        'userId': userId,
        'userEmail': userEmail,
        'userName': userName,
        'question': question,
        'answer': answer,
        'topic': topic,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'answered',
      });
      print('Question saved in Firestore: $question');
    } catch (e) {
      print('ERROR: não foi possível salvar pergunta no Firestore: $e');
      throw e;
    }
  }


  Future<List<Map<String, dynamic>>> getPerguntasSimilares(String pergunta) async {
    try {
      final snapshot = await _db.collection('questions')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      final perguntasSimilares = snapshot.docs
          .where((doc) => _isPerguntaSimilar(pergunta, doc['question']))
          .take(5)
          .map((doc) => doc.data())
          .toList();

      return perguntasSimilares;
    } catch (e) {
      print('ERROR: não foi possível buscar perguntas similares: $e');
      return [];
    }
  }

  bool _isPerguntaSimilar(String pergunta1, String pergunta2) {
    final palavras1 = pergunta1.toLowerCase().split(' ');
    final palavras2 = pergunta2.toLowerCase().split(' ');
    
    final palavrasComuns = palavras1.where((palavra) => palavras2.contains(palavra)).length;
    
    return palavrasComuns >= 2;
  }

  Future<Map<String, dynamic>> getRespostasFrequentes(String topico) async {
    try {
      final snapshot = await _db.collection('questions')
          .where('topic', isEqualTo: topico)
          .limit(10)
          .get();

      if (snapshot.docs.isEmpty) return {};

      final contadorRespostas = <String, int>{};
      
      for (final doc in snapshot.docs) {
        final resposta = doc['answer'] as String;
        contadorRespostas[resposta] = (contadorRespostas[resposta] ?? 0) + 1;
      }

      final respostaMaisFrequente = contadorRespostas.entries
          .reduce((a, b) => a.value > b.value ? a : b);

      return {
        'resposta': respostaMaisFrequente.key,
        'frequencia': respostaMaisFrequente.value,
        'totalPerguntas': snapshot.docs.length,
      };
    } catch (e) {
      print('ERROR, não foi possível buscar respostas frequentes: $e');
      return {};
    }
  }

  Stream<QuerySnapshot> getUserQuestions(String userId) {
    return _db.collection('questions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}