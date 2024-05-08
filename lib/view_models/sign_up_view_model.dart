import "package:firebase_auth/firebase_auth.dart";
import 'package:google_sign_in/google_sign_in.dart';





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

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }


  Future <void> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await userCredential.user!.updateDisplayName(fullname);


      //this just for test when the model add i will make sure that is work

      /*

      String uid = userCredential.user!.uid;


      Users newUser =Users(
        id:uid,
        username:fullname,
        email:email,
        budgetId: null,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid).
          set(newUser.toMap());
      */
      // Navigator.pushReplacementNamed(context, '/createBudget');
    }
    catch (e) {
      //when make the tird partis i will handel the error here
      print('Error signing up with email: $e');
    }
  }


  void navigateToLoginPage() {
    // Navigator.pushReplacementNamed(context, '/login');

  }
}