import 'package:budget_buddy/res/custom_color.dart';
import 'package:budget_buddy/utils/valedation.dart';
import 'package:budget_buddy/view_models/forgot_password_viewmodel.dart';
import 'package:budget_buddy/views/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});
  final ForgotPasswordViewModel forgotPasswordViewModel =
      ForgotPasswordViewModel();

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignInScreen()))),
        title: const Text("BudgetBuddy",
            style: TextStyle(color: AppColors.secondary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Enter your email address below. We\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (await widget.forgotPasswordViewModel
                      .checkEmail(_emailController.text.trim())) {
                    await widget.forgotPasswordViewModel
                        .sendPasswordResetEmail(_emailController.text, context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  } else {
                    widget.forgotPasswordViewModel.showErrorSnackbar(
                        context, "There is no account with this email");
                  }
                },
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(250, 70)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.tertiary),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(color: AppColors.secondary, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
