import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class BudgetProvider with ChangeNotifier {
  Budget? _currentBudget;
  String? _currentMonthName;

  Budget? get currentBudget => _currentBudget;
  String? get currentMonthName => _currentMonthName;

  Future<void> fetchBudget() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('budget')
          .get();

      DateTime now = DateTime.now();
      String currentMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

      final budgets = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        String fromDateStr = data['fromDate'];
        DateTime fromDate = DateTime.parse(fromDateStr);
        String budgetMonth = "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}";
        if (budgetMonth == currentMonth) {
          _currentMonthName = _formatMonth(fromDate.month);
          return Budget.fromJson(data);
        }
        return null;
      }).where((budget) => budget != null).toList();

      if (budgets.isEmpty) {
        print("No budgets found for the month: $currentMonth");
        _currentBudget = null;
        _currentMonthName = null;
      } else {
        _currentBudget = budgets.first;
      }
    } catch (e) {
      print("Error fetching budget: $e");
      _currentBudget = null;
      _currentMonthName = null;
    }

    notifyListeners();
  }

  Future<void> fetchCurrentMonthFromFirebase() async {
    await fetchBudget();
  }

  String _formatMonth(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}