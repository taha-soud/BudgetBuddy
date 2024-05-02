import 'package:flutter/material.dart';
import '../view_models/sign_up_view_model.dart';

class SignUpPage extends StatelessWidget {
  final SignUpViewModel viewModel = SignUpViewModel();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00838F),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 200.0, 16.0, 16.0), // here replace with the App bar
          child: SignUpForm(),
        ),
      ),
    );
  }

}

//i cant make widget file and but the SignUpForm inside it and here just ask the class i will ask about it

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Sign up for BudgetBuddy',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20.0),
        ElevatedButton.icon(
          onPressed: () {
            // logic for google (here put the function wil be write in ViewModel for this page )
          },
          icon: const Icon(Icons.smart_button),
          label: const Text('Sign up with Google'),  // replace hre the google button
        ),
        const SizedBox(height: 20.0),
        const Row(
          children: [
            Expanded(
              child: Divider(color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'or',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Full Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        Column(
          children: [
            TextButton(
              onPressed: () {
                // logic to route me to login page the function will be write in viewmodel
              },
              child: const Text(

                'Already have an account?',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // logic to signup with email
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(201, 51)),
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF09719D).withOpacity(0.57)),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
