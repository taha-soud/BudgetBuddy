import 'package:budget_buddy/views/profile_screen.dart';
import 'package:flutter/material.dart';

import '../res/custom_color.dart';

class MyAccountSettingsScreen extends StatelessWidget {
  const MyAccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const ProfileScreen()))
        ),
        title: const Text("My Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,  // Center the title
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

    );
  }
}
