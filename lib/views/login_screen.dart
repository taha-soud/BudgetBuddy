import 'package:budget_buddy/views/home_screen.dart';
import 'package:budget_buddy/views/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import '../view_models/login_viewmodel.dart';
import '/views/forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  final SignInViewModel viewModel = SignInViewModel();
  SignInViewModel signUpViewModel = SignInViewModel();


  SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SignInViewModel viewModel = SignInViewModel();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("BudgetBuddy", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Sign in to your account',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => viewModel.signInWithEmail(
                        emailController.text, passwordController.text, context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.tertiary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Sign in'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Image.asset('assets/icons/google-icon.png',
                        height: 24, width: 24),
                    label: const Text('Google'),
                    onPressed: () async {
                      try {
                        await widget.signUpViewModel.signInWithGoogle();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));

                      } on FirebaseAuthException catch (e) {
                        String errorMessage = 'Failed to sign in with Google';
                        if (e.code == 'account-exists-with-different-credential') {
                          errorMessage =
                          'The account already exists with a different credential.';
                        } else if (e.code == 'invalid-credential') {
                          errorMessage = 'Invalid credentials, please try again.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errorMessage),
                          duration: const Duration(seconds: 5),
                        ));
                      } catch (error) {
                        print("Failed to sign in with Google: $error");
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to sign in with Google'),
                          duration: Duration(seconds: 5),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.tertiary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage()),
                );
              },
              child: const Text('Don’t have an account? Signup here',
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}