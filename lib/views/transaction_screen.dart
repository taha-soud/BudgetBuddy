import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../res/custom_color.dart';
import '../utils/handling-date.dart';
import '../utils/icons.dart';
import '../view_models/transactions_viewmodel.dart';
import 'bottom_bar.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = TransactionPageViewModel();  // Initialize your view model

    return BottomBar(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Transactions', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search Transactions',
                  filled: true,
                  fillColor: AppColors.secondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                style: const TextStyle(color: AppColors.primary),
                onChanged: (value) {
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.filter_list, color: AppColors.secondary),
                  onPressed: () {
                    // Implement filter logic here
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: viewModel.getAllTransactionsWithCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No transactions found', style: TextStyle(color: Colors.white)));
                    }

                    // Group transactions by date
                    final groupedTransactions = <String, List<Map<String, dynamic>>>{};
                    for (var item in snapshot.data!) {
                      var transaction = item['transaction'] as Transactions;
                      var dateCategory = formatDate(transaction.date);
                      if (!groupedTransactions.containsKey(dateCategory)) {
                        groupedTransactions[dateCategory] = [];
                      }
                      groupedTransactions[dateCategory]!.add(item);
                    }

                    return ListView(
                      children: groupedTransactions.entries.map((entry) {
                        var date = entry.key;
                        var transactions = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ...transactions.map((item) {
                              var transaction = item['transaction'] as Transactions;
                              var categoryName = item['categoryName'] as String;
                              var categoryIcon = item['categoryIcon'] as String;  // Icon name from Firestore

                              return Card(
                                color: AppColors.secondary,
                                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(getIconData(categoryIcon), size: 40, color: AppColors.tertiary),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              categoryName,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              transaction.description,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat('yyyy-MM-dd – kk:mm').format(transaction.date),
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
