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
      print('✅ Usuário salvo no Firestore: $email');
    } catch (e) {
      print('❌ Erro ao salvar usuário no Firestore: $e');
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
        'status': 'answered', // ou 'pending' se for para responder depois
      });
      print('✅ Pergunta salva no Firestore: $question');
    } catch (e) {
      print('❌ Erro ao salvar pergunta no Firestore: $e');
      throw e;
    }
  }


  Stream<QuerySnapshot> getUserQuestions(String userId) {
    return _db.collection('questions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}