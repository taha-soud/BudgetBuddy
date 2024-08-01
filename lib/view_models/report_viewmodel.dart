import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

class ReportViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchTransactions(bool isWeekly) async {
    final user = _auth.currentUser;
    if (user == null) {
      return {'error': 'No user logged in'};
    }

    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: isWeekly ? 7 : 30));

    try {
      final transactionSnapshot = await _firestore
          .collection('transaction')
          .where('userId', isEqualTo: user.uid)
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .get();

      Map<String, Map<String, dynamic>> categoryDetails = {};
      for (var doc in transactionSnapshot.docs) {
        Transactions transaction =
            Transactions.fromJson(doc.data() as Map<String, dynamic>);
        var categoryDoc = await _firestore
            .collection('category')
            .doc(transaction.categoryId)
            .get();
        var categoryName = categoryDoc.data()?['name'] ?? 'Unknown Category';
        var categoryIcon = categoryDoc.data()?['icon'] ?? 'Icons.help';

        if (!categoryDetails.containsKey(categoryName)) {
          categoryDetails[categoryName] = {
            'totalAmount': 0.0,
            'totalCount': 0,
            'categoryIcon': categoryIcon,
          };
        }
        categoryDetails[categoryName]?['totalAmount'] += transaction.amount;
        categoryDetails[categoryName]?['totalCount']++;
      }

      return {'success': categoryDetails};
    } catch (e) {
      print('Error fetching transactions: $e');
      return {'error': 'Failed to fetch transactions'};
    }
  }
}
