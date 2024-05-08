import 'package:budget_buddy/views/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00838F),  // Set the background color of the page
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Customize the back arrow color
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInScreen())) // Pop current screen off the navigation stack
        ),
        title: const Text("BudgetBuddy", style: TextStyle(color: Colors.white)), // Customize the title
        centerTitle: true,  // Center the title
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove shadow from the AppBar
      ),

    );
  }
}
