import 'package:budget_buddy/view_models/budget_view_model.dart';
import 'package:budget_buddy/views/add_budget_screen.dart';
import 'package:budget_buddy/views/bottom_bar.dart';
import 'package:budget_buddy/views/edit_budget_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetViewModel(context),
      child: Consumer<BudgetViewModel>(
        builder: (_, viewModel, __) {
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
                            onPressed: () => viewModel.navigateBack(context),
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            iconSize: 35,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                viewModel.months[viewModel.currentMonthIndex],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 28),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => viewModel.navigateForward(context),
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                            iconSize: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                  Consumer<BudgetProvider>(
                    builder: (_, budgetProvider, __) {
                      final currentBudget = budgetProvider.currentBudget;
                      return budgetCard(
                        currentBudget ??
                            Budget(
                              id: '',
                              fromDate: DateTime.now(),
                              toDate: DateTime.now(),
                              totalRemaining: 1,
                              totalBudget: 1,

                               budgetName: '',
                               note: ''

                            ),
                      );
                    },
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
      ),
    );
  }

  Widget budgetCard(Budget budget) => Center(
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                            color: const Color.fromARGB(255, 208, 208, 208),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Consumer<BudgetViewModel>(
                            builder: (_, viewModel, __) {
                              return Text(
                                '${viewModel.months[viewModel.currentMonthIndex]} Budget',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: budget.totalRemaining / budget.totalBudget,
                  backgroundColor: Colors.grey[300],
                  minHeight: 10,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${budget.totalRemaining.toStringAsFixed(2)} of \$${budget.totalBudget.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );

  Widget addEditButtons() => Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditBudgetScreen()));

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiary,
              fixedSize: const Size(300, 70),
            ),
            child: const Text('Edit Budget',
                style: TextStyle(color: Colors.white), textScaleFactor: 1.5),
          ),
        ),
      );
}
