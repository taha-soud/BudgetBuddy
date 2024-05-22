import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart'; // Make sure this path is correct
import '../models/transaction_model.dart'; // Make sure this path is correct
import '../res/custom_color.dart'; // Make sure this path is correct
import '../view_models/add_expense_viewmodel.dart'; // Make sure this path is correct
import 'home_screen.dart'; // Make sure this path is correct
import 'category_screen.dart'; // Make sure this path is correct

class ExpenseScreen extends StatefulWidget {
  Category? selectedCategory;

  ExpenseScreen({Key? key, this.selectedCategory}) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final viewModel = ExpenseViewModel();

  @override
  void initState() {
    super.initState();
    amountController.text = '0.0'; // Default amount
    categoryController.text = widget.selectedCategory?.name ?? 'Select Category';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
        ),
        title: const Text("Expense", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40.0),  // Increased top padding to move everything down
            const Text(
              'How much?',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10.0),  // Space before amount input
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '\$0.0',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ),
            const Divider(color: Colors.white70, height: 30, thickness: 0.5),  // Divider right under the amount
            const SizedBox(height: 20.0),  // Space after divider
            TextField(
              controller: categoryController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
              onTap: () async {
                final selectedCategory = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
                if (selectedCategory != null) {
                  setState(() {
                    widget.selectedCategory = selectedCategory as Category;
                    categoryController.text = widget.selectedCategory!.name;
                  });
                }
              },
            ),
            const SizedBox(height: 20.0),  // Space before description
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 50.0),  // Space before save button
            Center(
              child: ElevatedButton(
                onPressed: () => viewModel.saveTransaction(context, widget.selectedCategory, amountController.text, descriptionController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  minimumSize: const Size(230, 60), // Set the size
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 23)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
