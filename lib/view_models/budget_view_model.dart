// viewmodels/budget_view_model.dart
import 'package:flutter/material.dart';
import '../services/budget_provider.dart';
import 'package:provider/provider.dart';

class BudgetViewModel extends ChangeNotifier {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  int currentMonthIndex = 0;

  BudgetViewModel(BuildContext context) {
    fetchBudgetForCurrentMonth(context);
  }

  void fetchBudgetForCurrentMonth(BuildContext context) {
    Provider.of<BudgetProvider>(context, listen: false)
        .fetchBudget(months[currentMonthIndex]);
  }

  void navigateBack(BuildContext context) {
    currentMonthIndex = (currentMonthIndex - 1) % months.length;
    if (currentMonthIndex < 0) {
      currentMonthIndex = months.length - 1;
    }
    fetchBudgetForCurrentMonth(context);
    notifyListeners();
  }

  void navigateForward(BuildContext context) {
    currentMonthIndex = (currentMonthIndex + 1) % months.length;
    fetchBudgetForCurrentMonth(context);
    notifyListeners();
  }
}
