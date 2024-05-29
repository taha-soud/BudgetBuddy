import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../res/custom_color.dart';
import '../utils/handling-date.dart';
import '../utils/icons.dart';
import '../view_models/transactions_viewmodel.dart';
import 'bottom_bar.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TransactionPageViewModel _viewModel = TransactionPageViewModel();
  String _searchQuery = '';
  String _sortBy = 'Name'; // Default sorting option

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title:
              const Text('Transactions', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: TransactionListView(
          viewModel: _viewModel,
          searchQuery: _searchQuery,
          sortBy: _sortBy,
          onSearchQueryChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onSortByChanged: (value) {
            setState(() {
              _sortBy = value;
            });
          },
        ),
      ),
    );
  }
}

class TransactionListView extends StatelessWidget {
  final TransactionPageViewModel viewModel;
  final String searchQuery;
  final String sortBy;
  final void Function(String) onSearchQueryChanged;
  final void Function(String) onSortByChanged;

  const TransactionListView({
    Key? key,
    required this.viewModel,
    required this.searchQuery,
    required this.sortBy,
    required this.onSearchQueryChanged,
    required this.onSortByChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search Transactions',
                    filled: true,
                    fillColor: AppColors.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                  ),
                  style: const TextStyle(color: AppColors.primary),
                  onChanged: onSearchQueryChanged,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.secondary),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        child: ListView(
                          children: <String>['Name', 'Date', 'Amount']
                              .map<Widget>((String value) {
                            return ListTile(
                              title: Text(value),
                              onTap: () {
                                Navigator.pop(context);
                                onSortByChanged(value);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
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
                  return const Center(
                    child: Text(
                      'No transactions found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Filter and sort transactions based on search query and sorting option
                var transactions = snapshot.data!;
                if (searchQuery.isNotEmpty) {
                  transactions = transactions.where((transaction) {
                    var categoryName = transaction['categoryName'] as String;
                    return categoryName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();
                }

                if (sortBy == 'Date') {
                  transactions.sort((a, b) =>
                      b['transaction'].date.compareTo(a['transaction'].date));
                } else if (sortBy == 'Amount') {
                  transactions.sort((a, b) => b['transaction']
                      .amount
                      .compareTo(a['transaction'].amount));
                } else {
                  transactions.sort(
                      (a, b) => a['categoryName'].compareTo(b['categoryName']));
                }

                // Group transactions by date
                final groupedTransactions =
                    <String, List<Map<String, dynamic>>>{};
                for (var item in transactions) {
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
                          var categoryIcon = item['categoryIcon']
                              as String; // Icon name from Firestore

                          return Card(
                            color: AppColors.secondary,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(getIconData(categoryIcon),
                                      size: 40, color: AppColors.tertiary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        DateFormat('yyyy-MM-dd – kk:mm')
                                            .format(transaction.date),
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
    );
  }
}
