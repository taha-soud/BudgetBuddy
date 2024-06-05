import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import 'package:flutter/material.dart';

class TransactionPageViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getAllTransactionsWithCategory() {
    var user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();
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
            'categoryIcon': categoryData['icon']
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

      bool matchesCategory =
          transaction['categoryName']?.toLowerCase().contains(query.toLowerCase()) ?? false;

      bool matchesAmount = false;
      try {
        double queryAmount = double.parse(query);
        matchesAmount = transactionData.amount == queryAmount;
      } catch (e) {
      }

      bool matchesDate = false;
      try {
        DateTime queryDate = DateTime.parse(query);
        matchesDate = transactionData.date == queryDate;
      } catch (e) {
      }

      return matchesCategory || matchesAmount || matchesDate;
    }).toList();

    return filteredTransactions;
  }

  Future<void> deleteTransaction(String transactionId) async {
    var user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot transactionDoc = await _firestore.collection('transaction').doc(transactionId).get();
    if (!transactionDoc.exists) return;
    double transactionAmount = (transactionDoc.data() as Map<String, dynamic>)['amount'];

    await _firestore.collection('transaction').doc(transactionId).delete();

    QuerySnapshot budgetQuery = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('budget')
        .limit(1)
        .get();

    if (budgetQuery.docs.isEmpty) return;
    DocumentSnapshot budgetDoc = budgetQuery.docs.first;

    double totalRemaining = (budgetDoc.data() as Map<String, dynamic>)['totalRemaining'] ?? 0;
    double updatedTotalRemaining = totalRemaining + transactionAmount;

    await _firestore.collection('users')
        .doc(user.uid)
        .collection('budget')
        .doc(budgetDoc.id)
        .update({'totalRemaining': updatedTotalRemaining});
  }
}
