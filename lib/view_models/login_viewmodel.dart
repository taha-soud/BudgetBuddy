import 'package:budget_buddy/views/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../views/forgot_password_screen.dart';
import '../views/home_screen.dart';
// import '../views/home_screen.dart';
// Make sure this points to your Home Screen

class SignInViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Invalid email or password.";
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  void navigateToForgotPassword(BuildContext context) {
    // Assuming ForgotPasswordScreen exists
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }
//
  void navigateToSignUp(BuildContext context) {
    // Assuming SignupScreen exists
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}