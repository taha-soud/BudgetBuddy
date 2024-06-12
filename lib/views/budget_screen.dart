import 'package:budget_buddy/view_models/budget_view_model.dart';
import 'package:budget_buddy/views/bottom_bar.dart';
import 'package:budget_buddy/views/edit_budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget_model.dart';
import '../res/custom_color.dart';
import '../services/budget_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetViewModel(Provider.of<BudgetProvider>(context, listen: false)),
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
                    color: AppColors.primary,
                    child: Center(
                      child: Text(
                        viewModel.currentMonthName.isEmpty
                            ? 'Loading...'
                            : '${viewModel.currentMonthName} Budget',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                  Consumer<BudgetProvider>(
                    builder: (_, budgetProvider, __) {
                      final currentBudget = budgetProvider.currentBudget;
                      return currentBudget == null
                          ? const Center(child: Text('No Budget Found'))
                          : budgetCard(currentBudget);
                    },
                  ),
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
            Text(
              '${budget.budgetName} Budget',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Remaining ₪${budget.totalRemaining.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: budget.totalRemaining / budget.totalBudget,
              backgroundColor: Colors.grey[300],
              minHeight: 10,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              '₪${budget.totalRemaining.toStringAsFixed(2)} of ₪${budget.totalBudget.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );

  Widget addEditButtons() => Column(
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditBudgetScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary,
          fixedSize: const Size(250, 70),
        ),
        child: const Text('Edit Income',
            style: TextStyle(color: Colors.white), textScaleFactor: 1.5),
      ),
    ],
  );
}