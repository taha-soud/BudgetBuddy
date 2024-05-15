import 'package:budget_buddy/views/add_budget_screen.dart';
import 'package:budget_buddy/views/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/budget_model.dart';
import '../res/custom_color.dart';
import '../services/budget_provider.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  int currentMonthIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetProvider>(context, listen: false)
          .fetchBudget(months[currentMonthIndex]);
    });
  }

  void _navigateBack() {
    setState(() {
      currentMonthIndex = (currentMonthIndex - 1) % months.length;
      if (currentMonthIndex < 0) {
        currentMonthIndex = months.length - 1;
      }
      Provider.of<BudgetProvider>(context, listen: false)
          .fetchBudget(months[currentMonthIndex]);
    });
  }

  void _navigateForward() {
    setState(() {
      currentMonthIndex = (currentMonthIndex + 1) % months.length;
      Provider.of<BudgetProvider>(context, listen: false)
          .fetchBudget(months[currentMonthIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (_, budgetProvider, __) {
        return BottomBar(
          currentIndex: 2,
          child: Scaffold(
            backgroundColor: AppColors.primary,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(72.0),
              child: AppBar(
                backgroundColor: AppColors.primary,
                title: const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('Budget',
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 1.5),
                ),
                centerTitle: true,
              ),
            ),
            body: ListView(
              children: [
                Container(
                  height: 100,
                  color: AppColors.primary, // Third row
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _navigateBack,
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          iconSize: 35,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              months[currentMonthIndex],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _navigateForward,
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          iconSize: 35,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 90),
                // if (currentBudget != null) ...[
                budgetCard(
                  budgetProvider.currentBudget ??
                      Budget(
                          id: '',
                          fromDate: DateTime.now(),
                          toDate: DateTime.now(),
                          totalRemaining: 1,
                          totalBudget: 1,
                          budgetName: '',
                          note: ''),
                ),
                // ] else ...[
                //   const Center(child: CircularProgressIndicator()),
                // ],
                const SizedBox(height: 90),
                addEditButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget budgetCard(Budget budget) => Center(
    child: Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color.fromARGB(255, 208, 208, 208),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        "${months[currentMonthIndex]} Budget",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Remaining \$${budget.totalRemaining.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: budget.totalRemaining / budget.totalBudget,
              backgroundColor: Colors.grey[300],
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              borderRadius: BorderRadius.circular(20),
            ),
            SizedBox(height: 10),
            Text(
              '\$${budget.totalRemaining.toStringAsFixed(2)} of \$${budget.totalBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );

  Widget addEditButtons() => Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBudgetScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  fixedSize: Size(200, 70),
                ),
                child: Text('Add Budget',
                    style: TextStyle(color: Colors.white),
                    textScaleFactor: 1.5),
              ),
              const SizedBox(width: 16), // Add spacing between the buttons
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    // Edit budget logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary,
                    fixedSize: Size(200, 70),
                  ),
                  child: Text('Edit Budget',
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 1.5),
                ),
              ),
            ],
          ),
        ),
      );
}
