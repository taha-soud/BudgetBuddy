import 'package:budget_buddy/views/profile_screen.dart';
import 'package:flutter/material.dart';

import '../res/custom_color.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const ProfileScreen()))
          ,
        ),
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            Container(
              height: 1,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 20),
            const Text(
              'By using Budget Buddy, you agree to our Terms and Conditions and Privacy Policy. '
                  'Budget Buddy is designed for personal and business budget tracking purposes, '
                  'and you are responsible for maintaining the confidentiality of your account information. '
                  'We collect personal information to improve your experience and may use third-party services '
                  'for analytics and payments. Your data is secured, and we do not guarantee the accuracy of app content. '
                  'By continuing to use Budget Buddy, you accept any updates to these policies.',
              style: TextStyle(color: AppColors.secondary,fontSize: 20,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

    );
  }
}
