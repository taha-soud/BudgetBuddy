import 'package:flutter/material.dart';
import 'nav_bar.dart';

class MyAccountSettingsScreen extends StatelessWidget {
  const MyAccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavBar(
      currentIndex: 3,  // Set the current index for the Profile screen
      child: Scaffold(
        backgroundColor: const Color(0xFF00838F),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('My Account', style: TextStyle(color: Colors.white)),
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

