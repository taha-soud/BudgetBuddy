import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/budget_model.dart';

class BudgetProvider with ChangeNotifier {
  Budget? _currentBudget;

  Budget? get currentBudget => _currentBudget;

  Future<void> fetchBudget(String month) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('budgets')
        .doc(month)
        .get();

    if (snapshot.exists) {
      _currentBudget = Budget.fromJson(snapshot.data()!);
      notifyListeners();
    }
  }
}
