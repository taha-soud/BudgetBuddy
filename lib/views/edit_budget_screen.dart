import 'package:budget_buddy/views/budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/budget_model.dart';
import '../res/custom_color.dart';
import '../view_models/edit_view_model.dart';
import '../views/home_screen.dart';
import '../views/you_are_set_screen.dart';

class EditBudgetScreen extends StatefulWidget {
  const EditBudgetScreen({super.key});

  @override
  _EditBudgetScreenState createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  final EditBudgetViewModel editBudgetViewModel = EditBudgetViewModel();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String selectedFrequency = 'Monthly';
  List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
  bool isSaving = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBudgetData();
  }

  Future<void> fetchBudgetData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await editBudgetViewModel.fetchBudget(currentUser.uid);
      if (editBudgetViewModel.currentBudget != null) {
        balanceController.text = editBudgetViewModel.currentBudget!.totalRemaining.toString();
        nameController.text = editBudgetViewModel.currentBudget!.budgetName;
        noteController.text = editBudgetViewModel.currentBudget!.note;
        selectedFrequency = calculatePeriod(editBudgetViewModel.currentBudget!);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  String calculatePeriod(Budget budget) {
    int days = budget.toDate.difference(budget.fromDate).inDays;
    if (days <= 1) return 'Daily';
    if (days <= 7) return 'Weekly';
    return 'Monthly';
  }

  void saveUpdatedBudget() async {
    setState(() {
      isSaving = true;
    });

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && editBudgetViewModel.currentBudget != null) {
      double parsedBalance = double.tryParse(balanceController.text) ?? 0.0; // Parse once and use for both
      Budget updatedBudget = Budget(
          id: editBudgetViewModel.currentBudget!.id, // Preserves the existing ID
          budgetName: nameController.text,
          totalRemaining: parsedBalance, // Assuming totalRemaining is initialized with the same value as totalBudget
          totalBudget: parsedBalance,
          note: noteController.text,
          fromDate: DateTime.now(), // Setting fromDate to now, adjust as necessary
          toDate: calculateToDate(DateTime.now(), selectedFrequency)
      );
      await editBudgetViewModel.updateBudget(currentUser.uid, updatedBudget);
    }

    setState(() {
      isSaving = false;
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BudgetScreen()));
  }


  DateTime calculateToDate(DateTime fromDate, String frequency) {
    switch (frequency) {
      case 'Daily':
        return fromDate.add(Duration(days: 1));
      case 'Weekly':
        return fromDate.add(Duration(days: 7));
      default:
        return fromDate.add(Duration(days: 30)); // Monthly by default
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BudgetScreen()))
        ),
        title: const Text("Edit Income", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: buildBudgetForm(),
    );
  }

  Widget buildBudgetForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20.0),
          const Text('Balance', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white)),
          TextField(
            controller: balanceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '₪0.0',
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
              onPressed: isSaving ? null : saveUpdatedBudget,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                minimumSize: const Size(230, 60), // Set the size
              ),
              child: isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 23)),
            ),
          ),
        ],
      ),
    );
  }
}
