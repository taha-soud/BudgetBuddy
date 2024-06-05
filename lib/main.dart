import 'package:budget_buddy/services/budget_provider.dart';
import 'package:budget_buddy/services/transaction_provider.dart';
import 'package:budget_buddy/view_models/add_budget_viewmodel.dart';
import 'package:budget_buddy/view_models/transactionSubCard_viewmodel.dart';
import 'package:budget_buddy/view_models/update_settings_viewmodel.dart';
import 'package:budget_buddy/view_models/notification_view_model.dart';
import 'package:budget_buddy/services/notifications_service.dart';
import 'package:budget_buddy/views/splash_screen.dart';
import 'package:budget_buddy/views/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_buddy/utils/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize time zone data
  tz.initializeTimeZones();

  // Initialize NotificationService and request permissions
  final NotificationService notificationService = NotificationService();
  await notificationService.requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => AddBudgetViewModel()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => TransactionsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel(notificationService)),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Buddy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SplashScreen(),
    );

  }
}
