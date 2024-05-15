import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/budget_model.dart';

class BudgetProvider with ChangeNotifier {

  Budget? _currentBudget;

  Budget? get currentBudget => _currentBudget;

  Future<void> fetchBudget([String month = '']) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> budgetSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser?.uid)
        .collection('budget')
        .get();

    List<String> budgetIds = budgetSnapshot.docs.map((doc) => doc.id).toList();
    if(budgetIds.isEmpty) {
      print("No budgets");
      return;
    }
    // filter by month

    print("sssssssssssssssssssssssssss::: ${budgetIds}");

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .collection('budget')
        .doc(budgetIds[0]) // send the filtered budget ID
        .get();

    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    print("AAAAAAAAAAAA::: ${data['totalRemaining']}");

    Budget budget = Budget.fromJson(data);
    _currentBudget = budget;


    notifyListeners();
    // User? currentUser = FirebaseAuth.instance.currentUser;
    // var snapshot = await FirebaseFirestore.instance
    //     .collection('budget')
    //     .doc(month)
    //     .get();
    //
    // if (snapshot.exists) {
    //   _currentBudget = Budget.fromJson(snapshot.data()!);
    //   notifyListeners();
    // }
  }
}
