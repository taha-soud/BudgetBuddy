import 'package:budget_buddy/services/budget_provider.dart';
import 'package:budget_buddy/view_models/add_budget_viewmodel.dart';
import 'package:budget_buddy/view_models/transactionSubCard_viewmodel.dart';
import 'package:budget_buddy/view_models/update_settings_viewmodel.dart';
import 'package:budget_buddy/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_buddy/utils/firebase_options.dart';
import 'views/home_screen.dart';

// Ensure you have firebase_options.dart configure
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => AddBudgetViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
      ],
      child: MyApp(),
    ),
  );
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
          home: const HomeScreen(),
        ));
  }
}
