import 'package:flutter/material.dart';
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
        currentIndex: currentIndex, // Active item index
        backgroundColor: const Color(0xFF00838F), // Teal background
        selectedItemColor: Colors.grey, // Grey color for the selected item icon and text
        unselectedItemColor: Colors.white, // White color for unselected items
        type: BottomNavigationBarType.fixed, // Fixed type for consistent positioning
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF00838F),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transaction',
            backgroundColor: Color(0xFF00838F),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budget',
            backgroundColor: Color(0xFF00838F),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color(0xFF00838F),
          ),
        ],
        onTap: (index) {
          viewModel.navigateTo(index, context); // Use ViewModel to handle navigation
        },
      ),
    );
  }
}
