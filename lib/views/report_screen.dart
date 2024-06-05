import 'package:budget_buddy/models/budget_model.dart';
import 'package:budget_buddy/services/budget_provider.dart';
import 'package:budget_buddy/services/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/custom_color.dart';
import '../utils/icons.dart'; // Utility to fetch icon data
import '../view_models/report_viewmodel.dart'; // Your ViewModel

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TransactionsProvider _transactionsProvider = TransactionsProvider();
  DateTime _selectedDate = DateTime.now();
  final ReportViewModel _viewModel = ReportViewModel();
  bool _isWeekly = true; // Default to weekly view
  Map<String, dynamic> _categoryData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    await _transactionsProvider.fetchTransactionsForCurrentUser();
    setState(() {}); // Update UI after fetching transactions
  }

  void _fetchData() async {
    var data = await _viewModel.fetchTransactions(_isWeekly);
    if (data.containsKey('success')) {
      setState(() {
        _categoryData = data['success'];
      });
    } else {
      print('Error fetching data');
    }
  }

  bool isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final TransactionsProvider _transactionsProvider = TransactionsProvider();
    Provider.of<BudgetProvider>(context, listen: false).fetchBudget();
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Report", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Consumer<BudgetProvider>(
              builder: (context, budgetProvider, _) {
                if (budgetProvider.currentBudget == null) {
                  return const CircularProgressIndicator(); // Show loading indicator while fetching data
                } else {
                  Budget budget = budgetProvider.currentBudget!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: isWeekly
                                  ? buildWeeklyBars(context, budget)
                                  : buildMonthlyBars(context, budget),
                            ),
                          ),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(24.0),
                            isSelected: [isWeekly, !isWeekly],
                            selectedColor: Colors.white,
                            fillColor: Colors.black,
                            color: Colors.black,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text("Weekly"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text("Monthly"),
                              ),
                            ],
                            onPressed: (index) {
                              setState(() {
                                isWeekly = index == 0;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Spacer(),
          _buildTimeToggle(),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Categories',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categoryData.length,
              itemBuilder: (context, index) {
                String key = _categoryData.keys.elementAt(index);
                var data = _categoryData[key];
                return Card(
                  color: AppColors
                      .secondary, // Assuming secondary is a lighter shade suitable for card background
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: Icon(getIconData(data['categoryIcon']),
                        color: AppColors.primary),
                    title: Text(key,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    subtitle: Text('${data['totalCount']} transactions',
                        style: TextStyle(color: Colors.grey[850])),
                    trailing: Text(
                        '-₪${data['totalAmount'].toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildWeeklyBars(BuildContext context, Budget? budget) {
    if (budget == null) {
      print("Budget is null");
      return List.filled(
          12, Container()); // Return empty containers until data is fetched
    }

    List<Widget> bars = [];
    DateTime startDate = budget
        .fromDate; // Assuming you have a fromDate field in your Budget model
    double dailyBudget = budget.totalBudget /
        30; // Assuming monthly budget divided equally by days

    for (int i = 0; i < 7; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      double expenses = _transactionsProvider.dailyExpenses(_selectedDate);
      double dailyExpenses = 9.0;
      double heightFactor = expenses / dailyBudget;
      print("heightFactor: $heightFactor");
      print("dailyExpenses: $dailyExpenses");
      print("dailyBudget: $dailyBudget");
      bars.add(
          buildBar(context, getDayLabel(currentDate.weekday), heightFactor));
    }

    return bars;
  }

  String getDayLabel(int weekday) {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1]; // Adjusting for 1-based index in DateTime.weekday
  }

  List<Widget> buildMonthlyBars(BuildContext context, Budget? budget) {
    if (budget == null) {
      print("Budget is null");
      return List.filled(
          12, Container()); // Return empty containers until data is fetched
    }

    List<Widget> bars = [];
    DateTime endDate = budget.toDate;
    double totalBudget = budget.totalBudget; // Cast to double
    double totalRemaining = budget.totalRemaining; // Cast to double

    for (int i = 0; i < 12; i++) {
      DateTime currentDate = DateTime(endDate.year, i + 1,
          1); // Create a DateTime object for the current month
      if (currentDate.month == endDate.month) {
        // Check if the current month matches the end date month
        double heightFactor = (totalBudget - totalRemaining) /
            totalBudget; // Calculate height factor directly
        if (heightFactor > 1.0) {
          heightFactor = 1.0;
        } else if (heightFactor < 0.0) {
          heightFactor = 0.0;
        }

        Color barColor = totalRemaining >= totalBudget
            ? Colors.red
            : Colors.black; // Use totalRemaining and totalBudget directly

        bars.add(buildBar(context, getMonthLabel(i), heightFactor,
            barColor)); // Pass i to getMonthLabel
      } else {
        bars.add(buildBar(context, getMonthLabel(i), 0.0));
      }
    }
    return bars;
  }

  String getMonthLabel(int index) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[index];
  }

  Widget buildBar(BuildContext context, String label, double heightFactor,
      [Color barColor = Colors.black]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 100,
          child: Stack(
            children: [
              Container(
                width: 20,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: heightFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Text(label),
      ],
    );
  }

  Widget _buildTimeToggle() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton('Weekly', _isWeekly),
            SizedBox(width: 8), // Spacing between buttons
            _buildToggleButton('Monthly', !_isWeekly),
          ],
        ),
      );

  Widget _buildToggleButton(String text, bool isSelected) => GestureDetector(
        onTap: () {
          setState(() {
            _isWeekly = text == 'Weekly';
            _fetchData();
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
