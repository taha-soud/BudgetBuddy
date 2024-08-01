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

  // Updates the existing budget, excluding totalRemaining
  Future<void> updateBudget(String userId, Budget updatedBudget) async {
    if (currentBudget == null) {
      print("No current budget to update");
      return;
    }

    try {
      // Calculate the difference between the updated total budget and the current total budget
      double budgetDifference = updatedBudget.totalBudget - currentBudget!.totalBudget;

      // Prepare the update data by removing totalRemaining from the updated budget
      Map<String, dynamic> updateData = updatedBudget.toJson();
      // Ensure totalRemaining is not updated
      updateData['totalRemaining'] = currentBudget!.totalRemaining + budgetDifference;

      // Perform the update on Firestore, including updating totalRemaining
      await firestore
          .collection('users')
          .doc(userId)
          .collection('budget')
          .doc(currentBudget!.id)  // Use the id from the fetched currentBudget
          .update(updateData);

      // Update the local currentBudget model
      currentBudget = Budget(
        id: currentBudget!.id,
        budgetName: updatedBudget.budgetName,
        note: updatedBudget.note,
        fromDate: updatedBudget.fromDate,
        toDate: updatedBudget.toDate,
        totalRemaining: currentBudget!.totalRemaining + budgetDifference,  // Update totalRemaining
        totalBudget: updatedBudget.totalBudget,
      );

      notifyListeners();
    } catch (e) {
      print("Error updating budget: $e");
      throw Exception("Failed to update budget: $e");
    }
  }
}
