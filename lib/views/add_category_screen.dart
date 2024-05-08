import 'package:flutter/material.dart';

import '../res/custom_color.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Add Category', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                // Action when the close icon is pressed
                Navigator.of(context).pop();
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
