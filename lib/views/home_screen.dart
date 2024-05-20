import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/custom_color.dart';
import '../res/pie.dart';
import 'bottom_bar.dart';
import 'dart:math' as Math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, double>> _totalSpentByCategory;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      setState(() {
        _totalSpentByCategory = calculateTotalSpentByCategory(userId);
      });
    } else {
      // If the user is not logged in, provide an empty map
      setState(() {
        _totalSpentByCategory = Future.value({});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('BudgetBuddy', style: TextStyle(color: Colors.white)),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spending by Category',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 2.0,
                ),
                FutureBuilder<Map<String, double>>(
                  future: _totalSpentByCategory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
                    } else {
                      final data = snapshot.data!;
                      final List<PieChartSectionData> sections = data.entries.map((entry) {
                        return PieChartSectionData(
                          color: getRandomColor(),
                          value: entry.value,
                          title: '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                          radius: 50,
                          titleStyle: const TextStyle(color: Colors.black, fontSize: 12),
                        );
                      }).toList();

                      return SizedBox(
                        height: 400.0,
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                            borderData: FlBorderData(show: false),
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                // Handle touch events if needed
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getRandomColor() {
    return Color((Math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
