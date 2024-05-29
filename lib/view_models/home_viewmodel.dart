import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, double>> calculateTotalSpentByCategory() async {
    final user = _auth.currentUser;
    if (user == null) {
      return {};
    }

    final categories = ['Lifestyle', 'Transportation', 'Food and Drink', 'My Categories'];
    final Map<String, double> spendingByCategory = {
      'Lifestyle': 0.0,
      'Transportation': 0.0,
      'Food and Drink': 0.0,
      'My Categories': 0.0,
    };

    double totalSpend = 0.0;

    try {
      // Fetch categories
      final categorySnapshot = await _firestore.collection('category').get();
      final Map<String, String> categoryTypeById = {
        for (var doc in categorySnapshot.docs)
          doc.id: doc.data()['type'] as String
      };

      // Fetch transactions
      final querySnapshot = await _firestore
          .collection('transaction')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        var categoryId = data['categoryId'] as String?;
        var amount = data['amount'];

        double amountDouble;
        if (amount is int) {
          amountDouble = amount.toDouble();
        } else if (amount is double) {
          amountDouble = amount;
        } else {
          continue;
        }

        totalSpend += amountDouble;

        if (categoryId != null && categoryTypeById.containsKey(categoryId)) {
          var categoryType = categoryTypeById[categoryId];
          if (categoryType != null && categories.contains(categoryType)) {
            spendingByCategory[categoryType] = spendingByCategory[categoryType]! + amountDouble;
          }
        }
      }

      spendingByCategory.removeWhere((key, value) => value == 0.0);
    } catch (e) {
      print('Error fetching data: $e');
    }

    return spendingByCategory;
  }
}
