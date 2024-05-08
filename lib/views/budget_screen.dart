import 'package:flutter/material.dart';
import 'bottom_bar.dart'; // Ensure this import points to where your PersistentNavBarScreen is defined

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 2,  // Set the current index for the Budget screen
      child: Scaffold(
        backgroundColor: const Color(0xFF00838F),
        appBar: AppBar(
          title: const Text('Budget', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF00838F),
        ),

      ),
    );
  }
}
