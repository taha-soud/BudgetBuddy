import 'package:budget_buddy/services/budget_provider.dart';
import 'package:budget_buddy/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/budget_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetProvider(),
      child: MaterialApp(
        title: 'Budget Buddy',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const BudgetScreen(), // Assuming BudgetScreen is the initial screen for now
      ),
    );
  }
}
