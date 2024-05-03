import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00838F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00838F),
        title: const Text('Category', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton( // Adding a back arrow icon
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // This will pop the current screen off the navigation stack
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Action when notification icon is pressed
            },
          )
        ],
      ),

    );
  }
}
