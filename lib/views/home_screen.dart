
import 'package:budget_buddy/views/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../res/custom_color.dart';
import 'bottom_bar.dart';
import '../view_models/home_viewmodel.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, double>> _totalSpentByCategory;
  double _totalSpend = 0.0;

  final HomeViewModel _viewModel = HomeViewModel();
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _totalSpentByCategory = _viewModel.calculateTotalSpentByCategory();
      _totalSpentByCategory.then((data) {
        setState(() {
          _totalSpend = data.values.fold(0.0, (sum, value) => sum + value);
        });
      });
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

          title: const Text('BudgetBuddy', style: TextStyle(color: AppColors.secondary)),
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
              child: FutureBuilder<Map<String, double>>(
                future: _totalSpentByCategory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  } else {
                    final data = snapshot.data ?? {};
                    final hasData = data.isNotEmpty;
                    final List<PieChartSectionData> sections = hasData
                        ? data.entries.map((entry) {
                      return PieChartSectionData(
                        color: getCategoryColor(entry.key),
                        value: entry.value,
                        title: entry.value.toStringAsFixed(2),
                        radius: 40,
                        titleStyle: const TextStyle(color: AppColors.secondary, fontSize: 12),
                      );
                    }).toList()
                        : [
                      PieChartSectionData(
                        color: Colors.grey,
                        value: 1,
                        title: '',
                        radius: 40,
                      )
                    ];

                    return Stack(
                      children: [
                        Card(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: AppColors.colorIcon, width: 3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 200.0,
                                        child: PieChart(
                                          PieChartData(
                                            sections: sections,
                                            centerSpaceRadius: 40,
                                            sectionsSpace: 2,
                                            borderData: FlBorderData(show: false),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "You've spent",
                                              style: TextStyle(
                                                color: AppColors.secondary,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              _totalSpend.toStringAsFixed(2),
                                              style: const TextStyle(
                                                color: AppColors.secondary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: hasData
                                        ? data.entries.map((entry) {
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
                                    }).toList()
                                        : [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 7.0),
                                        child: Text(
                                          'No spending data available',
                                          style: TextStyle(color: AppColors.secondary),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 9,
                          right: 11,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ReportScreen()
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.secondary, backgroundColor: AppColors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('See Report'),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
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
