import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00838F),  // Set the background color of the page
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Customize the back arrow color
          onPressed: () => Navigator.of(context).pop(), // Pop current screen off the navigation stack
        ),
        title: const Text("Notifications", style: TextStyle(color: Colors.white)), // Customize the title
        centerTitle: true,  // Center the title
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove shadow from the AppBar
      ),

    );
  }
}
