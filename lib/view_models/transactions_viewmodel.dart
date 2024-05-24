import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import 'package:flutter/material.dart';

class TransactionPageViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to fetch all transactions for the current user and include category details
  Stream<List<Map<String, dynamic>>> getAllTransactionsWithCategory() {
    var user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();  // Returns an empty stream if the user is not logged in.
    }

    return _firestore
        .collection('transaction')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap((transactionSnapshot) async {
      List<Map<String, dynamic>> transactionsWithCategories = [];

      for (var transactionDoc in transactionSnapshot.docs) {
        var transactionData = transactionDoc.data() as Map<String, dynamic>;
        var categorySnapshot = await _firestore.collection('category').doc(transactionData['categoryId']).get();
        var categoryData = categorySnapshot.data() as Map<String, dynamic>?;
        if (categoryData != null) {
          transactionsWithCategories.add({
            'transaction': Transactions.fromJson(transactionData),
            'categoryName': categoryData['name'],
            'categoryIcon': categoryData['icon']  // Icon name as string
          });
        }
      }

      return transactionsWithCategories;
    });
  }
}
