import 'package:flutter/material.dart';
import '../services/budget_provider.dart';

class BudgetViewModel extends ChangeNotifier {
  final BudgetProvider budgetProvider;
  String currentMonthName = '';

  BudgetViewModel(this.budgetProvider) {
    fetchCurrentMonthBudget();
  }

  void fetchCurrentMonthBudget() async {
    await budgetProvider.fetchCurrentMonthFromFirebase();
    currentMonthName = budgetProvider.currentMonthName ?? 'Current Month';
    notifyListeners();
  }
}