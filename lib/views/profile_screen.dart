import 'package:flutter/material.dart';
import 'nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavBar(
      currentIndex: 3,  // Set the current index for the Profile screen
      child: Scaffold(
        backgroundColor: const Color(0xFF00838F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF00838F),
        ),
        body: Container(
          color: const Color(0xFF00838F),
        ),
      ),
    );
  }
}

