

import 'package:budget_buddy/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel {
  Future<String?> getUserName() async{

    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName;
  }

  Future<void> logout(BuildContext context) async {
    // Display logout confirmation dialog
    bool logoutConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const SizedBox(
            width: 400,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you sure you want to logout?',
                  style: TextStyle(
                    fontSize: 18,
                  ),

                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );


    if (logoutConfirmed) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } catch (e) {
        print('Error signing out: $e');

      }

    }
  }



}

