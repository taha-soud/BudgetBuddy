import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import '../views/home_screen.dart';
// Make sure this points to your Home Screen

class SignInViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Invalid email or password.";
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

//   void navigateToForgotPassword(BuildContext context) {
//     // Assuming ForgotPasswordScreen exists
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
//   }
//
//   void navigateToSignUp(BuildContext context) {
//     // Assuming SignupScreen exists
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
//   }
}
