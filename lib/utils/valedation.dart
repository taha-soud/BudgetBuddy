import 'package:firebase_auth/firebase_auth.dart';

class Validator{

  static String? validateFullName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  static String? validateEmail(String? email){
    if (email == null || email.isEmpty) {
      return 'Please enter your full name';

    }

    final RegExp emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;

  }

  static String? validatePassword(String? password){
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    return null;

  }
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static Future<String?> validateEmailAvailability(String email) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: '',
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      } else {
        return 'Failed to check email availability';
      }
    } catch (error) {
      return 'Failed to check email availability';
    }
  }

}