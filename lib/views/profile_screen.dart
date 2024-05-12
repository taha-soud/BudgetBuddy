import 'package:budget_buddy/views/about_app_screen.dart';
import 'package:budget_buddy/views/my_account_settings.dart';
import 'package:budget_buddy/views/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import 'bottom_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Center(
            child: Column(
              children: [
                const Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: AppColors.secondary,
                        child: Icon(
                          Icons.person,
                          size: 120,
                          color: AppColors.colorIcon,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Izz Moqbel',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  height: 200,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('My Account'),
                            subtitle: const Text('Make changes to your account'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const MyAccountSettingsScreen()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Log Out'),
                            subtitle: const Text('Log out from here'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Perform log out action
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'More',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: Card(
                    color: AppColors.secondary,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Privacy Policy'),
                            subtitle: const Text('View privacy policy'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const PrivacyPolicyScreen()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ListTile(
                            leading: const Icon(Icons.favorite),
                            title: const Text('About App'),
                            subtitle: const Text('Learn more about the app'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const AboutAppScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
