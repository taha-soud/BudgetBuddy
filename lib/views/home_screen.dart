

import 'package:budget_buddy/views/notification_screen.dart';
import 'package:budget_buddy/views/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../res/custom_color.dart';
import '../utils/icons.dart';
import '../view_models/home_viewmodel.dart';
import '../view_models/transactionSubCard_viewmodel.dart';
import 'bottom_bar.dart';
import 'expense_screen.dart';
import 'report_screen.dart';
import 'transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, double>> _totalSpentByCategory;
  late Future<List<Transactions>> _lastTwoTransactions;
  late Future<Map<String, double>> _budgetOverview;
  final HomeViewModel _viewModel = HomeViewModel();
  final TransactionViewmodel _viewModels = TransactionViewmodel();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _totalSpentByCategory = _viewModel.calculateTotalSpentByCategory();
      _lastTwoTransactions = _viewModels.fetchLastTwoTransactions();
      _budgetOverview = _viewModel.fetchBudgetOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'BudgetBuddy',
            style: TextStyle(color: AppColors.secondary),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.secondary),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Map<String, double>>(
                future: _budgetOverview,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white)));
                  } else {
                    final data = snapshot.data ?? {'Income': 0.0, 'Outcome': 0.0, 'Left': 0.0};
                    return SizedBox(
                      height: 90,
                      child: Card(
                        color: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: AppColors.tertiary, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildBudgetInfo('Income', data['Income']!, Colors.white),
                              _buildBudgetInfo('Outcome', data['Outcome']!, Colors.white),
                              _buildBudgetInfo('Left', data['Left']!, Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, double>>(
                future: _totalSpentByCategory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white)));
                  } else {
                    final data = snapshot.data ?? {};
                    final sections = _buildPieChartSections(data);

                    return Stack(
                      children: [
                        Card(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                color: AppColors.tertiary, width: 3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 150.0,
                                  width: 150.0,
                                  child: PieChart(
                                    PieChartData(
                                      sections: sections,
                                      centerSpaceRadius: 30,
                                      sectionsSpace: 2,
                                      borderData: FlBorderData(show: false),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildCategoryList(data),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ReportScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.secondary,
                              backgroundColor: AppColors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('See Report',
                                style: TextStyle(
                                    color: AppColors.secondary, fontSize: 12)),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Transactions>>(
                future: _lastTwoTransactions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading transactions: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final transactions = snapshot.data ?? [];
                    return SizedBox(
                      height: 200, // Adjusted height
                      child: _buildTransactionCard(transactions),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpenseScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 13),
                  ),
                  child: const Text(
                    'Add Expense',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetInfo(String title, double amount, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          '\$$amount',
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }


  List<PieChartSectionData> _buildPieChartSections(Map<String, double> data) {
    if (data.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: '',
          radius: 30,
        )
      ];
    }

    return data.entries.map((entry) {
      return PieChartSectionData(
        color: getCategoryColor(entry.key),
        value: entry.value,
        title: entry.value.toStringAsFixed(2),
        radius: 30,
        titleStyle: const TextStyle(color: AppColors.secondary, fontSize: 12),
      );
    }).toList();
  }

  Widget _buildCategoryList(Map<String, double> data) {
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 7.0),
        child: Text(
          'No spending data available',
          style: TextStyle(color: AppColors.secondary),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                color: getCategoryColor(entry.key),
              ),
              const SizedBox(width: 5),
              Text(
                entry.key,
                style: const TextStyle(color: AppColors.secondary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTransactionCard(List<Transactions> transactions) {
    return Card(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.tertiary, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransactionScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    backgroundColor: AppColors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                  ),
                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppColors.secondary, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...transactions.isNotEmpty
                ? transactions.map((transaction) {
              return FutureBuilder<Category>(
                future: _viewModels.fetchCategoryById(transaction.categoryId),
                builder: (context, categorySnapshot) {
                  if (categorySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (categorySnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading category: ${categorySnapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final category = categorySnapshot.data!;
                    final categoryName = category.name;
                    final categoryIcon = getIconData(category.icon);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            categoryIcon,
                            color: AppColors.secondary,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(categoryName,
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 16)),
                                Text(transaction.description,
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '-₪${transaction.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('kk:mm')
                                    .format(transaction.date),
                                style: const TextStyle(
                                    color: AppColors.secondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }).toList()
                : [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 7.0),
                child: Text(
                  'No recent transactions',
                  style: TextStyle(color: AppColors.secondary),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Lifestyle':
        return Colors.blue;
      case 'Transportation':
        return Colors.green;
      case 'Food and Drink':
        return Colors.orange;
      case 'My Categories':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

}
