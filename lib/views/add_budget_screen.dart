import 'package:budget_buddy/views/home_screen.dart';
import 'package:flutter/material.dart';
import '../res/custom_color.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  _AddBudgetScreenState createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  String selectedFrequency = 'Monthly'; // Default value
  List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
  bool isDropdownOpened = false;
  final TextEditingController balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    balanceController.text = '0.0';  // Initial balance value
  }

  @override
  void dispose() {
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()))
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '\$0.0',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
            const SizedBox(height: 20.0),
            TextField(
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
              icon: Icon(isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.black),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              onSaved: (newValue) {
                setState(() {
                  selectedFrequency = newValue!;
                });
              },
              onChanged: (String? newValue) {
                setState(() {
                  selectedFrequency = newValue!;
                  isDropdownOpened = !isDropdownOpened;
                });
              },
              items: frequencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onTap: () {
                setState(() {
                  isDropdownOpened = !isDropdownOpened;
                });
              },
            ),
            const SizedBox(height: 50.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement saving functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: const Size(230, 60), // Set the size
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white,fontSize:23)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
