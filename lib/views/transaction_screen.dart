import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import 'bottom_bar.dart';
class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Transactions', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
