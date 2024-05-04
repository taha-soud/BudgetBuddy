import 'package:flutter/material.dart';
import 'nav_bar.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavBar(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: Color(0xFF00838F),
        appBar: AppBar(
          backgroundColor: Color(0xFF00838F),
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
        body: Container(
          color: const Color(0xFF00838F), // Keeping the background consistent
        ),
      ),
    );
  }
}
