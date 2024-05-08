import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import 'bottom_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

