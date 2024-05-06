import 'package:flutter/material.dart';
import '../views/budget_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_screen.dart';
import '../views/transaction_screen.dart';
class BottomBarViewModel {
  void navigateTo(int index, BuildContext context) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const TransactionScreen();
        break;
      case 2:
        screen = const BudgetScreen();
        break;
      case 3:
        screen = const ProfileScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }
}
