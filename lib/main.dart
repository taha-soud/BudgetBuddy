import 'package:budget_buddy/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/splash_screen.dart'; // Import the splash screen widget
import 'views/budget_screen.dart';

Future <void> main()async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
options: DefaultFirebaseOptions.currentPlatform;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Buddy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    // Start with the SplashScreen
      home:  const BudgetScreen() // Start with the SplashScreen
    );
  }
}




