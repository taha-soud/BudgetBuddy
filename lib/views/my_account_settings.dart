import 'package:budget_buddy/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/custom_color.dart';
import '../utils/valedation.dart';
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
            onPressed: () => Navigator.pop(context)
        ),
        title: const Text("My Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
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
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeDetailScreen(detailType: title)
          ));
        },
      ),
      color: AppColors.tertiary,
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context); // Now this should work without errors

    return Scaffold(
      appBar: AppBar(
        title: Text('Change ${widget.detailType}', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: AppColors.primary,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter new ${widget.detailType}',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: widget.detailType == "Password",
                validator: (value) => userViewModel.validateDetail(value, widget.detailType),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Update ${widget.detailType}', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String result = await userViewModel.updateUserDetail(widget.detailType, _controller.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                    if (result.endsWith("successfully.")) {
                      Navigator.pop(context); // Optionally pop the screen if update is successful
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
