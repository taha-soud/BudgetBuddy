import 'package:budget_buddy/views/profile_screen.dart';
import 'package:flutter/material.dart';

import '../res/custom_color.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const ProfileScreen()))
        ),
        title: const Text("About App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            Container(
              height: 1,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Budget buddy, your go-to budget tracking solution. '
                  'We\'re dedicated to simplifying finances and helping you achieve your financial goals effortlessly. '
                  'With Budget buddy, managing your budget is a breeze. Join us today and take control of your finances with ease!',
              style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

    );
  }
}
