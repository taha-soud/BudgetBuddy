import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class ExpenseViewModel {
  void saveTransaction(BuildContext context, Category? category, String amount, String description) {
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a category'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final transaction = Transactions(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseAuth.instance.currentUser?.uid ?? 'Unknown',  // Use Firebase Auth to get the current user's ID
      categoryId: category.id,
      amount: double.parse(amount),
      date: DateTime.now(),
      description: description,
    );

    FirebaseFirestore.instance.collection('transaction').doc(transaction.id).set(transaction.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Transaction saved successfully'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save transaction: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
