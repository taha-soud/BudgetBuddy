// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:budget_buddy/views/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../res/custom_color.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  int currentMonthIndex = 0;

  void _navigateBack() {
    setState(() {
      currentMonthIndex = (currentMonthIndex - 1) % months.length;
      if (currentMonthIndex < 0) {
        currentMonthIndex = months.length - 1;
      }
    });
  }

  void _navigateForward() {
    setState(() {
      currentMonthIndex = (currentMonthIndex + 1) % months.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72.0),
          child: AppBar(
            backgroundColor: AppColors.primary,
            title: const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Budget',
                  style: TextStyle(color: Colors.white), textScaleFactor: 1.5),
            ),
            centerTitle: true,
          ),
        ),
        body: ListView(
          children: [
            Container(
              height: 100,
              color: AppColors.primary, // Third row
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _navigateBack,
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      iconSize: 35,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          months[currentMonthIndex],
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _navigateForward,
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.white,
                      iconSize: 35,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox.fromSize(size: Size.fromHeight(90)),
            Container(
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 208, 208, 208),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Text(
                                    months[currentMonthIndex] + " Budget",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Remaining \$500',
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 15,
                          child: LinearProgressIndicator(
                            value: (2500 / 3000),
                            semanticsValue: '25%',
                            backgroundColor: Colors.grey[300],
                            minHeight: 10,
                            semanticsLabel: 'Linear progress indicator',
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '\$2500 of \$3000',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(size: Size.fromHeight(90)),
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add budget logic
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.tertiary, // Customize button color
                          fixedSize: Size(200, 70)),
                      child: Text('Add Budget',
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.5),
                    ),
                    SizedBox(width: 16), // Add spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        // Edit budget logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.tertiary, // Customize button color
                        fixedSize: Size(200, 70),
                      ),
                      child: Text(
                        'Edit Budget',
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
