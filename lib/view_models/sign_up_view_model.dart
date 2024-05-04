import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";





class SignUpViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUpWithGoogle() {
  //logic for signup with google
  }

  Future <void>  signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user!.updateDisplayName(fullname);
    }
    catch(e){
      print('Error signing up with email: $e');


    }
  }
}
  void navigateToLoginPage() {
    //logic for go to loginPage
  }