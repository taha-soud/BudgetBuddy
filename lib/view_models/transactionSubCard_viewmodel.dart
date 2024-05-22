import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionViewModel extends ChangeNotifier {
  String title = '';
  String description = '';
  String amount = '';
  String time = '';

  Future<void> fetchLastTransaction() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print('Fetching last transaction for user: ${user.uid}');

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('transaction')
            .where('userId', isEqualTo: user.uid) // Use user's actual ID here
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          print('Fetched transaction data:');
          print('Description: ${data['description']}');
          print('Amount: ${data['amount']}');
          print('Time: ${data['time']}');

          description = data['description'];
          amount = data['amount'];
          time = data['time'];
          notifyListeners();
        } else {}
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
