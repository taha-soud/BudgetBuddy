import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00838F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00838F),
        title: const Text('BudgetBuddy', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Action when notification icon is pressed
            },
          )
        ],
      ),

    );
  }
}
