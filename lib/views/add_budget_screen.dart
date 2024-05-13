import 'package:budget_buddy/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/custom_color.dart';
import '../view_models/add_budget_viewmodel.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  _AddBudgetScreenState createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final BudgetViewModel budgetViewModel = BudgetViewModel();  // Initializing the view model
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String selectedFrequency = 'Monthly'; // Default frequency
  List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
  bool isSaving = false;  // Used to manage the state of the save operation

  @override
  void initState() {
    super.initState();
    balanceController.text = '0.0';  // Initial balance value
  }

  @override
  void dispose() {
    balanceController.dispose();
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
        ),
        title: const Text("Add Budget", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Text(
              'Balance',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '\$0.0',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Budget name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            DropdownButtonFormField<String>(
              value: selectedFrequency,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFrequency = newValue!;
                });
              },
              items: frequencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 50.0),
            Center(
              child: ElevatedButton(
                onPressed: isSaving ? null : () async {
                  setState(() {
                    isSaving = true;
                  });
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    if (nameController.text.isEmpty || balanceController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields'), backgroundColor: Colors.red)
                      );
                    } else {
                      await budgetViewModel.saveBudget(
                          currentUser.uid,
                          balanceController.text,
                          nameController.text,
                          noteController.text,
                          selectedFrequency
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Budget saved successfully'), backgroundColor: Colors.green)
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No user signed in'), backgroundColor: Colors.red)
                    );
                  }
                  setState(() {
                    isSaving = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: const Size(230, 60), // Set the size
                ),
                child: isSaving ? CircularProgressIndicator(color: Colors.white) : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 23)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
