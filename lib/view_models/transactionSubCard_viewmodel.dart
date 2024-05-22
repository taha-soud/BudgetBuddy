import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';

class HomeViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Transactions>> fetchLastTwoTransactions() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      final querySnapshot = await _firestore
          .collection('transaction')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .limit(2)
          .get();

      return querySnapshot.docs
          .map((doc) => Transactions.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  Future<Category> fetchCategoryById(String categoryId) async {
    try {
      final categorySnapshot =
          await _firestore.collection('category').doc(categoryId).get();
      if (categorySnapshot.exists) {
        final data = categorySnapshot.data();
        return Category(
          id: data?['id'] ?? 'unknown',
          userId: data?['userId'] ?? '',
          name: data?['name'] ?? 'Unknown',
          type: data?['type'] ?? 'unknown',
          icon: data?['icon'] ?? 'Icons.error',
        );
      } else {
        return Category(
            id: 'unknown',
            userId: '',
            name: 'Unknown',
            type: 'unknown',
            icon: 'Icons.error');
      }
    } catch (e) {
      print('Error fetching category: $e');
      return Category(
          id: 'unknown',
          userId: '',
          name: 'Unknown',
          type: 'unknown',
          icon: 'Icons.error');
    }
  }
}
