import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/valedation.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<String> updateUserDetail(String detailType, String newValue, [String? confirmPassword]) async {
    try {
      switch (detailType) {
        case 'Username':
          await _firestore.collection('users').doc(currentUser!.uid).update({'username': newValue});
          await currentUser!.updateDisplayName(newValue);
          break;
        case 'Email':
          String? emailValidation = Validator.validateEmail(newValue); // Validate email format
          if (emailValidation != null) return emailValidation;

          await currentUser!.verifyBeforeUpdateEmail(newValue);
          await _firestore.collection('users').doc(currentUser!.uid).update({'email': newValue});
          break;
        case 'Password':
          String? passwordValidation = Validator.validatePassword(newValue); // Validate new password
          if (passwordValidation != null) return passwordValidation;

          String? confirmPasswordValidation = Validator.validateConfirmPassword(confirmPassword, newValue); // Confirm password match
          if (confirmPasswordValidation != null) return confirmPasswordValidation;

          await currentUser!.updatePassword(newValue);
          break;
        default:
          return 'Invalid detail type';
      }
      notifyListeners();
      return "$detailType updated successfully.";
    } catch (e) {
      print('Error updating $detailType: $e'); // Log error
      return "Failed to update $detailType. ${e.toString()}";
    }
  }
}
