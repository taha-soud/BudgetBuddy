import 'package:budget_buddy/view_models/update_settings_viewmodel.dart';
import 'package:budget_buddy/views/login_screen.dart';
import 'package:budget_buddy/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_buddy/utils/firebase_options.dart'; // Ensure this is correctly set up

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserViewModel>(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        title: 'Budget Buddy',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
