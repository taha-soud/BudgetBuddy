import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/budget_model.dart';

class EditBudgetViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Budget? currentBudget;

  // Fetches the first budget found for a given user
  Future<void> fetchBudget(String userId) async {
    try {
      QuerySnapshot budgetQuery = await firestore
          .collection('users')
          .doc(userId)
          .collection('budget')
          .limit(1)  // Assumes there is only one budget per user
          .get();

      if (budgetQuery.docs.isNotEmpty) {
        currentBudget = Budget.fromJson(budgetQuery.docs.first.data() as Map<String, dynamic>);
        notifyListeners();
      } else {
        print("No budget found for the user");
      }
    } catch (e) {
      print("Error fetching budget: $e");
      throw Exception("Failed to fetch budget: $e");
    }
  }

  // Updates the existing budget
  Future<void> updateBudget(String userId, Budget updatedBudget) async {
    if (currentBudget == null) {
      print("No current budget to update");
      return;
    }
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('budget')
          .doc(currentBudget!.id)  // Use the id from the fetched currentBudget
          .update(updatedBudget.toJson());
      currentBudget = updatedBudget;
      notifyListeners();
    } catch (e) {
      print("Error updating budget: $e");
      throw Exception("Failed to update budget: $e");
    }
  }
}
