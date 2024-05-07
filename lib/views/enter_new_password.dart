import 'package:flutter/material.dart';

class EnterNewPassword extends StatelessWidget {
  const EnterNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00838F),  // Set the background color of the page
      appBar: AppBar(

        title: const Text("BudgetBuddy", style: TextStyle(color: Colors.white)), // Customize the title
        centerTitle: true,  // Center the title
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove shadow from the AppBar
      ),

    );
  }
}
