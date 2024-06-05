import 'package:budget_buddy/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/custom_color.dart';
import '../view_models/update_settings_viewmodel.dart';

class MyAccountSettingsScreen extends StatelessWidget {
  const MyAccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));

          },
        ),
        title: const Text("My Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            "Update your account details below.",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
          buildAccountOption(
            context,
            "Username",
            userViewModel.currentUser?.displayName ?? "Not set",
          ),
          buildAccountOption(
            context,
            "Password",
            "********", // Do not show the actual password
          ),
        ],
      ),
    );
  }

  Widget buildAccountOption(BuildContext context, String title, String currentValue) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.tertiary,
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text("Current: $currentValue", style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeDetailScreen(detailType: title),
            ),
          );
        },
      ),
    );
  }
}

class ChangeDetailScreen extends StatefulWidget {
  final String detailType;

  const ChangeDetailScreen({super.key, required this.detailType});

  @override
  _ChangeDetailScreenState createState() => _ChangeDetailScreenState();
}

class _ChangeDetailScreenState extends State<ChangeDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _confirmObscureText = true;
  bool _currentObscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change ${widget.detailType}', style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your new ${widget.detailType.toLowerCase()} below:',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              if (widget.detailType == "Password") ...[
                buildPasswordField("Enter current password", _currentPasswordController, _currentObscureText, () {
                  setState(() {
                    _currentObscureText = !_currentObscureText;
                  });
                }),
                const SizedBox(height: 20),
                buildPasswordField("Enter new password", _controller, _obscureText, () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }),
                const SizedBox(height: 20),
                buildPasswordField("Confirm new password", _confirmController, _confirmObscureText, () {
                  setState(() {
                    _confirmObscureText = !_confirmObscureText;
                  });
                }),
                const SizedBox(height: 20),
              ],
              if (widget.detailType != "Password") ...[
                buildTextField("Enter new ${widget.detailType}", _controller),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    String result = await userViewModel.updateUserDetail(
                      widget.detailType,
                      _controller.text.trim(),
                      widget.detailType == "Password" ? _confirmController.text.trim() : null,
                      widget.detailType == "Password" ? _currentPasswordController.text.trim() : null,
                    );

                    setState(() {
                      _isLoading = false;
                    });

                    // Determine the SnackBar color based on the result
                    Color snackBarColor = result.endsWith("successfully.")
                        ? Colors.green
                        : Colors.red;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                        backgroundColor: snackBarColor,
                      ),
                    );

                    if (result.endsWith("successfully.")) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiary),
                child: _isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text('Update ${widget.detailType}', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(widget.detailType == "Username" ? Icons.person : Icons.email, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white),
          onPressed: toggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        if (label == "Confirm new password") {
          if (value != _controller.text) {
            return "Passwords do not match";
          }
        } else if (label == "Enter current password" && controller == _currentPasswordController) {
          if (value == null || value.isEmpty) {
            return "Current password is required";
          }
        }
        return null;
      },
    );
  }
}
