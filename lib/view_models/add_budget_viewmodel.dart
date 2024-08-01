import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/budget_model.dart';

class AddBudgetViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;  // Firebase Authentication instance
  final Uuid uuid = Uuid();

  Future<void> saveBudget(String userId, String balance, String name, String note, String frequency) async {
    Budget newBudget = _createBudget(balance, name, note, frequency);

    try {
      // Save the budget under the user-specific 'budgets' sub-collection
      await firestore
          .collection('users')
          .doc(userId)  // Use the passed user ID
          .collection('budget')
          .doc(newBudget.id)
          .set(newBudget.toJson());
      print("Budget saved successfully under user $userId");
    } catch (e) {
      print("Error saving budget: $e");
    }
  }

  Budget _createBudget(String balance, String name, String note, String frequency) {
    DateTime now = DateTime.now();
    DateTime toDate;

    switch (frequency) {
      case 'Daily':
        toDate = now.add(Duration(days: 1));
        break;
      case 'Weekly':
        toDate = now.add(Duration(days: 7));
        break;
      case 'Monthly':
      default:
        toDate = now.add(Duration(days: 30));
        break;
    }

    return Budget(
      id: uuid.v4(),
      budgetName: name,
      note: note,
      fromDate: now,
      toDate: toDate,
      totalRemaining: double.tryParse(balance) ?? 0.0,
      totalBudget: double.tryParse(balance) ?? 0.0,
    );
  }
}
