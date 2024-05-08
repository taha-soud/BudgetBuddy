import 'package:flutter/material.dart';
import 'bottom_bar.dart';
class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 1,  // Set the current index for the Transaction screen
      child: Scaffold(
        backgroundColor: const Color(0xFF00838F),
        appBar: AppBar(
          title: const Text('Transactions', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF00838F),
        ),
        body: Container(
          color: const Color(0xFF00838F),
        ),
      ),
    );
  }
}
