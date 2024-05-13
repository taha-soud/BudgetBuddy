import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';





class SignUpViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  Future<void> signUpWithGoogle() async {
    try {

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // User signed in successfully
        String uid = user.uid;
        String email = user.email ?? '';
        String username = user.displayName ?? '';

        Users newUser =Users(
          id:uid,
          username: username,
          email:email,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid).
        set(newUser.toJson());

      }

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }
  Future<String?> checkEmailInUse(String email) async {
    try {
      var signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        return "The email address is already in use by another account.";
      }
      return null;
    } catch (e) {
      return "Failed to check email: ${e.toString()}";
    }
  }

  Future<void> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      // Check if the email is already in use before creating a new user
      await checkEmailInUse(email);

      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // Update display name
      await userCredential.user!.updateDisplayName(fullname);

      // Create a new user document in Firestore
      String uid = userCredential.user!.uid;
      Users newUser = Users(
          id: uid,
          username: fullname,
          email: email,
      );

      // Save the new user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set(newUser.toJson());

      // Optionally, you can send a verification email here
      await userCredential.user!.sendEmailVerification();

    } catch (e) {
      // Handle all errors in the calling UI to inform the user appropriately
      rethrow;  // Use rethrow to pass the error up to the UI layer
    }
  }

  void navigateToLoginPage() {
    // This method would navigate back to the login page, implement as needed
  }
}