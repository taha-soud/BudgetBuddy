import 'package:budget_buddy/res/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatefulWidget {
  final bool isDailyView;

  ReportCard({Key? key, required this.isDailyView}) : super(key: key);

  @override
  _ReportCardState createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  QuerySnapshot<Map<String, dynamic>>? _snapshot;
  Map<String, double>? _weeklyExpenses;
  List<Map<String, dynamic>>? _fetchedData;

  @override
  void initState() {
    super.initState();
    _fetchUserTransactions();
    _fetchUserBudget();
  }

  bool? checkBudgetType(List<Map<String, dynamic>> fetchedData) {
    bool isMonthlyBudget(String fromDate, String toDate) {
      DateTime from = DateTime.parse(fromDate);
      DateTime to = DateTime.parse(toDate);
      Duration difference = to.difference(from);
      return (difference.inDays >= 28 && difference.inDays <= 31);
    }

    for (var data in fetchedData) {
      bool isMonthly = isMonthlyBudget(data['fromDate'], data['toDate']);
      if (isMonthly) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  double getTotalBudget(List<Map<String, dynamic>> fetchedData) {
    double totalBudget = 0.0;
    for (var data in fetchedData) {
      totalBudget = data['totalBudget'].toDouble();
    }
    return totalBudget;
  }

  double getRemainingBudget(List<Map<String, dynamic>> fetchedData) {
    double totalRemaining = 0.0;
    for (var data in fetchedData) {
      totalRemaining = data['totalRemaining'].toDouble();
    }
    return totalRemaining;
  }

  void _fetchUserBudget() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budget')
        .get();

    var fetchedData = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _fetchedData = fetchedData;
    });

    print('Fetched budget data: $_fetchedData');
  }

  void _fetchUserTransactions() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      _snapshot = snapshot;
      _weeklyExpenses = _getWeeklyExpenses(snapshot);
    });

    print('Fetched transaction data: ${snapshot.docs.length} transactions');
  }

  Map<String, double> _getWeeklyExpenses(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday));

    Map<String, double> dailyExpenses = {};
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      dailyExpenses[DateFormat('EEEE').format(day)] = 0.0;
    }

    List<Map<String, dynamic>> userTransactions = snapshot.docs
        .where((doc) =>
            doc.data()['userId'] == FirebaseAuth.instance.currentUser?.uid &&
            DateTime.parse(doc.data()['date'])
                .isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            DateTime.parse(doc.data()['date'])
                .isBefore(today.add(Duration(days: 1))))
        .map((doc) => doc.data())
        .toList();

    for (var transaction in userTransactions) {
      DateTime transactionDate = DateTime.parse(transaction['date']);
      String dayName = DateFormat('EEEE').format(transactionDate);
      if (dailyExpenses.containsKey(dayName)) {
        dailyExpenses[dayName] =
            (dailyExpenses[dayName] ?? 0) + transaction['amount'];
      }
    }

    return dailyExpenses;
  }

  Map<String, double> _getMonthlyExpenses(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    DateTime today = DateTime.now();
    DateTime startOfYear = DateTime(today.year, 1, 1);

    Map<String, double> monthlyExpenses = {};
    for (int i = 0; i < 12; i++) {
      DateTime month = DateTime(today.year, i + 1, 1);
      monthlyExpenses[DateFormat('MMMM').format(month)] = 0.0;
    }

    List<Map<String, dynamic>> userTransactions = snapshot.docs
        .where((doc) =>
            doc.data()['userId'] == FirebaseAuth.instance.currentUser?.uid &&
            DateTime.parse(doc.data()['date'])
                .isAfter(startOfYear.subtract(Duration(days: 1))) &&
            DateTime.parse(doc.data()['date'])
                .isBefore(today.add(Duration(days: 1))))
        .map((doc) => doc.data())
        .toList();

    for (var transaction in userTransactions) {
      DateTime transactionDate = DateTime.parse(transaction['date']);
      String monthName = DateFormat('MMMM').format(transactionDate);
      if (monthlyExpenses.containsKey(monthName)) {
        monthlyExpenses[monthName] =
            (monthlyExpenses[monthName] ?? 0) + transaction['amount'];
      }
    }
    return monthlyExpenses;
  }

  double _calculateDayHeightFactor(
      List<Map<String, dynamic>> fetchedData, double dailyExpense) {
    bool? budgetType = checkBudgetType(fetchedData);
    double totalBudget;

    if (budgetType == true) {
      totalBudget = getTotalBudget(fetchedData) / 30;
    } else {
      totalBudget = getTotalBudget(fetchedData) / 7;
    }

    double heightFactor = dailyExpense / totalBudget;
    if (heightFactor < 0) {
      heightFactor = 0;
    } else if (heightFactor > 1) {
      heightFactor = 1;
    }
    return heightFactor.isFinite && heightFactor > 0 ? heightFactor : 0.0;
  }

  double _calculateMonthHeightFactor(
      List<Map<String, dynamic>> fetchedData, double monthlyExpense) {
    double heightFactor = monthlyExpense / getTotalBudget(fetchedData);
    return heightFactor.isFinite && heightFactor > 0 ? heightFactor : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: 430,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: _snapshot != null && _fetchedData != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: (widget.isDailyView
                      ? _weeklyExpenses
                      : _getMonthlyExpenses(_snapshot!))!
                  .entries
                  .map((entry) {
                double heightFactor = widget.isDailyView
                    ? _calculateDayHeightFactor(_fetchedData!, entry.value)
                    : _calculateMonthHeightFactor(_fetchedData!, entry.value);
                return buildBar(context, entry.key.substring(0, 3),
                    heightFactor, AppColors.textColor);
              }).toList(),
            )
          : const CircularProgressIndicator(),
    );
  }
}

Widget buildBar(
    BuildContext context, String label, double heightFactor, Color color) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 20,
        height: 130,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: heightFactor,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    ],
  );
}
