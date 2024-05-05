import 'package:flutter/material.dart';
import 'home_screen.dart';  // Make sure these imports are correctly pointing to your screen files
import 'transaction_screen.dart';
import 'budget_screen.dart';
import 'profile_screen.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const NavBar({Key? key, required this.currentIndex, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // Active item index
        backgroundColor: const Color(0xFF00838F), // Teal background
        selectedItemColor: Colors.grey, // Grey color for the selected item icon and text
        unselectedItemColor: Colors.white, // White color for unselected items
        selectedLabelStyle: const TextStyle(color: Colors.grey), // Style for selected label
        unselectedLabelStyle: const TextStyle(color: Colors.white), // Style for unselected labels
        type: BottomNavigationBarType.fixed, // Fixed type for consistent positioning
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF00838F), // Ensuring background color is consistent for each item
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
          // Handle navigation based on index tapped
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TransactionScreen()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BudgetScreen()));
              break;
            case 3:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              break;
          }
        },
      ),
    );
  }
}
