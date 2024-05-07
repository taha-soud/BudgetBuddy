import 'package:flutter/material.dart';
import '../view_models/sign_up_view_model.dart';


class SignUpPage extends StatefulWidget {
  final SignUpViewModel viewModel = SignUpViewModel();
  SignUpViewModel signUpViewModel = SignUpViewModel();
  SignUpPage({Key? key}) : super(key: key);


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

//i can make widget file and put the SignUpForm inside it and here just ask the class. i will ask about it

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpViewModel? viewModel;
  get signUpViewModel => null;

  @override
  void initState() {
    super.initState();
    viewModel = SignUpViewModel();  // Ensuring the ViewModel is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00838F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 200.0, 16.0, 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Sign up for BudgetBuddy',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  icon: Image.asset('assets/icons/google.png', height: 24.0),
                  label: const Text("Sign in with Google"),
                  onPressed: () {
                    widget.signUpViewModel.signInWithGoogle().catchError((error) {
                      print("Failed to sign in with Google: $error");
                    });
                  },

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
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (_) => _formKey.currentState!.validate(),
                  //validator: Validator.validateFullName,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (_) => _formKey.currentState!.validate(),
                //  validator: Validator.validateEmail,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  onChanged: (_) => _formKey.currentState!.validate(),
                 // validator: Validator.validatePassword,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (_) => _formKey.currentState!.validate(),
                 // validator: (value) => Validator.validateConfirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: 10.0),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        //widget.viewModel.navigateToLoginPage();
                      },
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {

                        if (_formKey.currentState!.validate()) {
                          widget.viewModel.signUpWithEmail(
                              fullname: _fullNameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim()
                          );
                        }
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
            ),
          ),
        ),
      ),
    );
  }
}
