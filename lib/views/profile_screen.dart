import 'package:budget_buddy/views/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import '../view_models/profile_view_model.dart';
import 'about_app_screen.dart';
import 'bottom_bar.dart';
import 'my_account_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: _viewModel.getUserName(),
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final userName = snapshot.data ?? 'User Name';
                      return Column(
                        children: [
                          const CircleAvatar(
                            radius: 80,
                            backgroundColor: AppColors.secondary,
                            child: Icon(
                              Icons.person,
                              size: 120,
                              color: AppColors.colorIcon,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      );
                    }
                  },
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
                              _viewModel.logout(context);
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const AboutAppScreen()));                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),              ],
            ),
          ),
        ),
      ),
    );
  }
}
