import 'package:budget_buddy/views/login_screen.dart';
import 'package:budget_buddy/views/sign_up_page.dart';
import 'package:flutter/material.dart';

import '../res/custom_color.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BudgetBuddy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Welcome to BudgetBuddy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/betting.png',
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Start Managing your finances better today!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInScreen() ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 7),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Get Started',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
