import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import '../view_models/bottom_bar_viewmodel.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final BottomBarViewModel viewModel = BottomBarViewModel(); // Instantiate the ViewModel

  BottomBar({super.key, required this.currentIndex, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transaction',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budget',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: AppColors.primary,
          ),
        ],
        onTap: (index) {
          viewModel.navigateTo(index, context); // Use ViewModel to handle navigation
        },
      ),
    );
  }
}
