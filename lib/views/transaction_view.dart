import 'package:budget_buddy/views/transaction_screen.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../res/custom_color.dart';
import '../utils/icons.dart';
import 'bottom_bar.dart';
import '../view_models/transactionSubCard_viewmodel.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Transactions>> _lastTwoTransactions;
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _lastTwoTransactions = _viewModel.fetchLastTwoTransactions();
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
          title: const Text('BudgetBuddy',
              style: TextStyle(color: AppColors.secondary)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.secondary),
              onPressed: () {
                // Action when notification icon is pressed
              },
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: FutureBuilder<List<Transactions>>(
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
                    return _buildTransactionCard(transactions);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(List<Transactions> transactions) {
    return Card(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.colorIcon, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Recent Transactions text and See All button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: ElevatedButton(
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
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'See All',
                      style:
                          TextStyle(color: AppColors.secondary, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...transactions.isNotEmpty
                ? transactions.map((transaction) {
                    return FutureBuilder<Category>(
                      future:
                          _viewModel.fetchCategoryById(transaction.categoryId),
                      builder: (context, categorySnapshot) {
                        if (categorySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                            padding: const EdgeInsets.symmetric(vertical: 7.0),
                            child: Row(
                              children: [
                                Icon(
                                  categoryIcon,
                                  color: AppColors.secondary,
                                  size: 40,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(categoryName,
                                          style: const TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 20)),
                                      Text(transaction.description,
                                          style: const TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        '\$${transaction.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        DateFormat('kk:mm')
                                            .format(transaction.date),
                                        style: const TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 16)),
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
}
