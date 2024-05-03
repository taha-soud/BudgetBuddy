import 'package:flutter/material.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00838F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00838F),
        title: const Text('Add Category', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                // Action when the close icon is pressed
                Navigator.of(context).pop(); // Optionally pop the screen or perform another action
              },
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              // Action when the check icon is pressed, like saving data
            },
          ),
        ],
      ),
      // Body content here if needed
    );
  }
}
