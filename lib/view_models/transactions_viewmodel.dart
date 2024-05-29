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
        var categorySnapshot = await _firestore
            .collection('category')
            .doc(transactionData['categoryId'])
            .get();
        var categoryData = categorySnapshot.data() as Map<String, dynamic>?;
        if (categoryData != null) {
          transactionsWithCategories.add({
            'transaction': Transactions.fromJson(transactionData),
            'categoryName': categoryData['name'],
            'categoryIcon': categoryData['icon'] // Icon name as string
          });
        }
      }

      return transactionsWithCategories;
    });
  }

  Future<List<Map<String, dynamic>>> searchTransactions(String query) async {
    List<Map<String, dynamic>> allTransactions =
        await getAllTransactionsWithCategory().first;

    List<Map<String, dynamic>> filteredTransactions =
        allTransactions.where((transaction) {
      var transactionData = transaction['transaction'] as Transactions;

      // Check if the query matches the category name
      bool matchesCategory =
          transaction['categoryName']?.toLowerCase() == query.toLowerCase();

      // Check if the query matches the amount
      bool matchesAmount = false;
      try {
        double queryAmount = double.parse(query);
        matchesAmount = transactionData.amount == queryAmount;
      } catch (e) {
        // Ignore if parsing fails, query is not an amount
      }

      // Check if the query matches the date
      bool matchesDate = false;
      try {
        DateTime queryDate = DateTime.parse(query);
        matchesDate = transactionData.date == queryDate;
      } catch (e) {
        // Ignore if parsing fails, query is not a date
      }

      return matchesCategory || matchesAmount || matchesDate;
    }).toList();

    return filteredTransactions;
  }
}
