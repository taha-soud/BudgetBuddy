import 'package:budget_buddy/models/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class TransactionsProvider with ChangeNotifier {
  List<Transactions> _transactions = [];

  List<Transactions> get transactions => _transactions;

  Future<void> fetchTransactionsForCurrentUser() async {
    try {
      print("fetchTransactionsForCurrentUser called");
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('Current user ID is null');
      }

      print("userId: $userId");

      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('transaction')
              .where('userId', isEqualTo: userId)
              .get();

      _transactions = snapshot.docs
          .map((doc) => Transactions.fromJson(doc.data()))
          .toList();

      notifyListeners();
      print("_transactions: $_transactions");
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  double dailyExpenses(DateTime day) {
    fetchTransactionsForCurrentUser();
    double totalExpenses = 0.0;

    // Filter transactions for the current user and specific day
    print("_transactions: $_transactions");
    List<Transactions> userTransactions = _transactions
        //
        .where((transaction) =>
            //
            transaction.userId == FirebaseAuth.instance.currentUser?.uid &&
            transaction.date.year == day.year &&
            transaction.date.month == day.month &&
            transaction.date.day == day.day)
        .toList();
    print(userTransactions);
    // Sum up the amount spent
    totalExpenses = userTransactions.fold(
        0.0, (total, transaction) => total + transaction.amount);

    print("totalExpenses: $totalExpenses");

    return totalExpenses;
  }
}
