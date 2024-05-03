import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  // Define the custom colors
  final Color mainColor = const Color(0xFF00838F);  // Main color #00838F
  final Color buttonColor = const Color(0xFF00838F).withOpacity(0.55);

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: const Text("BudgetBuddy", style: TextStyle(color: Colors.white)), // Title color set to white
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          const Text(
          'Sign in to your account',
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Sign in'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: buttonColor, // Text color
                    minimumSize: const Size(double.infinity, 50) // Button width and height
                ),
              ),
            ),
            const SizedBox(width: 10), // Spacing between buttons
            Expanded(
              child: ElevatedButton.icon(
                icon: Container(
                  color: buttonColor,  // Matching the button background color
                  padding: const EdgeInsets.all(2),  // Small padding around the icon
                  child: Image.asset('assets/icons/google-icon.png', height: 24, width: 24),
                ),
                label: const Text('Google'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: buttonColor, // Text color
                    minimumSize: const Size(double.infinity, 50) // Button width and height
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {},
          child: Text('Forgot Password?'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Text color
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {},
          child: const Text('Dont have an account? Signup here',
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      ],
    ),
    ),
    );
  }
}
