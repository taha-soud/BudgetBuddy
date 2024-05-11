import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import 'bottom_bar.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('BudgetBuddy', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Action when notification icon is pressed
              },
            )
          ],
        ),
        body: Container(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
