import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ SALVAR USUÁRIO
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
      print('✅ Usuário salvo no Firestore: $email');
    } catch (e) {
      print('❌ Erro ao salvar usuário no Firestore: $e');
      throw e;
    }
  }

  // ✅ SALVAR PERGUNTA NO CHAT
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
      print('✅ Pergunta salva no Firestore: $question');
    } catch (e) {
      print('❌ Erro ao salvar pergunta no Firestore: $e');
      throw e;
    }
  }

  // ✅ BUSCAR PERGUNTAS SIMILARES DO BANCO
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
      print('❌ Erro ao buscar perguntas similares: $e');
      return [];
    }
  }

  // ✅ VERIFICA SE AS PERGUNTAS SÃO SIMILARES
  bool _isPerguntaSimilar(String pergunta1, String pergunta2) {
    final palavras1 = pergunta1.toLowerCase().split(' ');
    final palavras2 = pergunta2.toLowerCase().split(' ');
    
    final palavrasComuns = palavras1.where((palavra) => palavras2.contains(palavra)).length;
    
    return palavrasComuns >= 2;
  }

  // ✅ BUSCAR RESPOSTAS MAIS FREQUENTES POR TÓPICO
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
      print('❌ Erro ao buscar respostas frequentes: $e');
      return {};
    }
  }

  // ✅ BUSCAR PERGUNTAS DO USUÁRIO
  Stream<QuerySnapshot> getUserQuestions(String userId) {
    return _db.collection('questions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}