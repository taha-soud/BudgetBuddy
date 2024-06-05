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

    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await userCredential.user!.updateDisplayName(fullname);

      String uid = userCredential.user!.uid;
      Users newUser = Users(
          id: uid,
          username: fullname,
          email: email,

      );

      await FirebaseFirestore.instance.collection('users').doc(uid).set(newUser.toJson());


    } catch (e) {
      rethrow;
    }
  }


}