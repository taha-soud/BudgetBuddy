import 'package:flutter/material.dart';
import 'dart:async'; // Required for using Timer
import '../main.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home Page')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00838F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_balance_wallet, size: 100, color: Colors.white), // An example icon
            Text('Welcome to Budget Buddy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Padding(
              padding: EdgeInsets.only(top: 20),

            ),
          ],
        ),
      ),
    );
  }
}
