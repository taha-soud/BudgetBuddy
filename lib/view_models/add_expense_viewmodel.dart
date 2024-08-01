import 'package:budget_buddy/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../view_models/notification_view_model.dart';

class ExpenseViewModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void saveTransaction(BuildContext context, Category? category, String amount, String description) async {
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a category'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final transaction = Transactions(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseAuth.instance.currentUser?.uid ?? 'Unknown',
      categoryId: category.id,
      amount: double.parse(amount),
      date: DateTime.now(),
      description: description,
    );

    var budgetRef = firestore.collection('users').doc(transaction.userId).collection('budget').limit(1);
    var querySnapshot = await budgetRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      var budgetDoc = querySnapshot.docs.first;
      double currentRemaining = budgetDoc.data()['totalRemaining'];
      double totalBudget = budgetDoc.data()['totalBudget'];

      // Check if the transaction amount is greater than the current remaining budget
      if (transaction.amount > currentRemaining) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You do not have enough balance in your account'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      try {
        await firestore.collection('transaction').doc(transaction.id).set(transaction.toJson());
        double newRemaining = currentRemaining - transaction.amount;
        await budgetDoc.reference.update({
          'totalRemaining': newRemaining
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Transaction saved successfully'),
          backgroundColor: Colors.green,
        ));

        Budget budget = Budget(
          id: budgetDoc.data()['id'],
          budgetName: budgetDoc.data()['budgetName'],
          note: budgetDoc.data()['note'],
          fromDate: DateTime.parse(budgetDoc.data()['fromDate']),
          toDate: DateTime.parse(budgetDoc.data()['toDate']),
          totalRemaining: newRemaining,
          totalBudget: budgetDoc.data()['totalBudget'],
        );

        // Log the budget information
        print("Budget details: $budget");

        // Call the checkAndSendBudgetThresholdAlert function
        NotificationViewModel notificationViewModel = Provider.of<NotificationViewModel>(context, listen: false);
        notificationViewModel.checkAndSendBudgetThresholdAlert(budget);

        // Navigate to Home Screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save transaction: $error'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No budget setup found for this user'),
        backgroundColor: Colors.red,
      ));
    }
  }
}