import 'package:budget_buddy/views/home_screen.dart';
import 'package:flutter/material.dart';
import '../res/custom_color.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = '0.0'; // Default amount
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
          }
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
            const SizedBox(height: 50.0), // Increased space to move design down
            const Text(
              'How much?',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
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
            const Divider(color: Colors.white70, height: 30, thickness: 0.5),  // Thin line separator
            TextField(
              // Category input field with navigation
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
              onTap: () {
                // Logic to navigate to category selection page
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              // Description input field
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
            const SizedBox(height: 50.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save button logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
