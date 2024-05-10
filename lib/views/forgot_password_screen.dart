import 'package:budget_buddy/res/custom_color.dart';
import 'package:budget_buddy/views/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF00838F), // Set the background color of the page
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.white), // Customize the back arrow color
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignInScreen())) // Pop current screen off the navigation stack
            ),
        title: const Text("BudgetBuddy",
            style: TextStyle(color: Colors.white)), // Customize the title
        centerTitle: true, // Center the title
        backgroundColor:
            Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove shadow from the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 60),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Enter your email address below. We\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 80),
            Container(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 70, // Set the height of the TextField
                width: 320, // Set the width of the TextField
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(30), // Set border radius to 30
                  color: Colors.white,
                ),

                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Add your password reset logic here
                },
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(250, 70)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.tertiary),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
