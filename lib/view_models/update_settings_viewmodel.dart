import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<String> updateUserDetail(String detailType, String newValue) async {
    try {
      switch (detailType) {
        case 'Username':
          await _firestore.collection('users').doc(currentUser!.uid).update({'username': newValue});
          break;
        case 'Email':
          await currentUser!.updateEmail(newValue);
          await _firestore.collection('users').doc(currentUser!.uid).update({'email': newValue});
          break;
        case 'Password':
          await currentUser!.updatePassword(newValue);
          break;
      }
      notifyListeners();
      return "$detailType updated successfully.";
    } catch (e) {
      return "Failed to update $detailType. ${e.toString()}";
    }
  }

  String? validateDetail(String? value, String detailType) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }

    switch (detailType) {
      case 'Email':
        return validateEmail(value);
      case 'Password':
        return validatePassword(value);
      default:
        return null;  // No validation for Username or other fields
    }
  }

  String? validateEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one digit';
    }
    return null;
  }
}
