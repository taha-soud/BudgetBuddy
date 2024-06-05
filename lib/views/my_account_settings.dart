import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/custom_color.dart';
import '../view_models/update_settings_viewmodel.dart';

class MyAccountSettingsScreen extends StatelessWidget {
  const MyAccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
          buildAccountOption(context, "Username"),
          buildAccountOption(context, "Email"),
          buildAccountOption(context, "Password"),
        ],
      ),
    );
  }

  Widget buildAccountOption(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.tertiary,
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true; // For new password
  bool _confirmObscureText = true; // For confirm password

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
            children: [
              if (widget.detailType == "Password") ...[
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
                TextFormField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter new ${widget.detailType}',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String result = await userViewModel.updateUserDetail(
                      widget.detailType,
                      _controller.text.trim(),
                      widget.detailType == "Password" ? _confirmController.text.trim() : null,
                    );

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
                child: Text('Update ${widget.detailType}', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white),
          onPressed: toggleVisibility,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      obscureText: obscureText,
      validator: label == "Confirm new password" ? (value) {
        if (value != _controller.text) {
          return "Passwords do not match";
        }
        return null;
      } : null,
    );
  }
}
