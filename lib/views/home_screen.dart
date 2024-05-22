import 'package:budget_buddy/view_models/transactionSubCard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/custom_color.dart';
import 'bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchTransactionFuture;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TransactionViewModel>(context, listen: false);
    _fetchTransactionFuture = viewModel.fetchLastTransaction();
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
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Action when notification icon is pressed
              },
            )
          ],
        ),
        body: Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 500,
            color: AppColors.primary,
            child: Card(
              color: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(width: 2, color: AppColors.colorIcon),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Text(
                            'Income',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              fixedSize: const Size(60, 25),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              backgroundColor: AppColors.tertiary,
                            ),
                            onPressed: () {
                              final viewModel =
                                  Provider.of<TransactionViewModel>(context,
                                      listen: false);
                              viewModel.fetchLastTransaction();
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<TransactionViewModel>(
                      builder: (context, model, child) {
                        // if (model.title.isEmpty) {
                        //   return const CircularProgressIndicator();
                        // } else {
                        return TransactionSubCard(
                          title: model.title,
                          description: model.description,
                          amount: model.amount,
                          time: model.time,
                          icon: const Icon(
                            Icons.account_balance_wallet,
                            size: 60,
                            color: AppColors.secondary,
                          ),
                        );
                        // }
                      },
                    ),
                    const SizedBox(height: 20),
                    // const TransactionSubCard(
                    //   title: 'Groceries',
                    //   description: 'Weekly grocery shopping',
                    //   amount: '- \$30',
                    //   time: '10:00 AM',
                    //   icon: Icon(
                    //     Icons.account_balance_wallet,
                    //     size: 60,
                    //     color: AppColors.secondary,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionSubCard extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String time;
  final Icon icon;

  const TransactionSubCard({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: icon,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
