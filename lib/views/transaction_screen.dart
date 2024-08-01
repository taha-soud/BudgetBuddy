import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../res/custom_color.dart';
import '../utils/handling-date.dart';
import '../utils/icons.dart';
import '../view_models/transactions_viewmodel.dart';
import 'bottom_bar.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TransactionPageViewModel _viewModel = TransactionPageViewModel();
  String _searchQuery = '';
  String _sortBy = 'Date';
  bool _ascending = true;

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
          ascending: _ascending,
          onSearchQueryChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onSortByChanged: (value, ascending) {
            setState(() {
              _sortBy = value;
              _ascending = ascending;
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
  final bool ascending;
  final void Function(String) onSearchQueryChanged;
  final void Function(String, bool) onSortByChanged;

  const TransactionListView({
    Key? key,
    required this.viewModel,
    required this.searchQuery,
    required this.sortBy,
    required this.ascending,
    required this.onSearchQueryChanged,
    required this.onSortByChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(1000.0, 100.0, 0.0, 0.0),
                    items: <String>['Name', 'Date', 'Amount']
                        .map<PopupMenuEntry<String>>((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: ListTile(
                          title: Text(value),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: sortBy == value && ascending
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  onSortByChanged(value, true);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: sortBy == value && !ascending
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  onSortByChanged(value, false);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                onSortByChanged('Date', true);
              },
              child: const Text(
                'Clear Filter',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: const Size(60, 0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
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
                  transactions.sort((a, b) => ascending
                      ? a['transaction'].date.compareTo(b['transaction'].date)
                      : b['transaction'].date.compareTo(a['transaction'].date));
                } else if (sortBy == 'Amount') {
                  transactions.sort((a, b) => ascending
                      ? a['transaction']
                          .amount
                          .compareTo(b['transaction'].amount)
                      : b['transaction']
                          .amount
                          .compareTo(a['transaction'].amount));
                } else {
                  transactions.sort((a, b) => ascending
                      ? a['categoryName'].compareTo(b['categoryName'])
                      : b['categoryName'].compareTo(a['categoryName']));
                }

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
                  children: (sortBy == 'Date' && ascending)
                      ? groupedTransactions.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              ...entry.value.map((item) {
                                var transaction =
                                    item['transaction'] as Transactions;
                                var categoryName =
                                    item['categoryName'] as String;
                                var categoryIcon =
                                    item['categoryIcon'] as String;

                                return Card(
                                  color: AppColors.secondary,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Icon(getIconData(categoryIcon),
                                              size: 40,
                                              color: AppColors.tertiary),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₪${transaction.amount.toStringAsFixed(2)}',
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
                                          IconButton(
                                            icon: Icon(Icons.more_vert,
                                                color: Colors.black),
                                            onPressed: () =>
                                                _showMenu(context, item),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList()
                      : transactions.map((item) {
                          var transaction = item['transaction'] as Transactions;
                          var categoryName = item['categoryName'] as String;
                          var categoryIcon = item['categoryIcon'] as String;

                          return Card(
                            color: AppColors.secondary,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Icon(getIconData(categoryIcon),
                                        size: 40, color: AppColors.tertiary),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '₪${transaction.amount.toStringAsFixed(2)}',
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
                                    IconButton(
                                      icon: Icon(Icons.more_vert,
                                          color: Colors.black),
                                      onPressed: () => _showMenu(context, item),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  void _showMenu(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 80,
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context, item);
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                viewModel.deleteTransaction(item['transaction'].id).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Transaction deleted successfully'),
                    duration: Duration(seconds: 2),
                  ));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to delete transaction'),
                    duration: Duration(seconds: 2),
                  ));
                });
              },
            ),
          ],
        );
      },
    );
  }
}
