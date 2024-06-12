import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import '../utils/icons.dart';
import '../view_models/report_viewmodel.dart';
import 'home_screen.dart';
import 'report_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportViewModel _viewModel = ReportViewModel();
  bool _isWeekly = true; // Default to weekly view
  Map<String, dynamic> _categoryData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
        title: const Text("Report", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ReportCard(isDailyView: _isWeekly),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Time Frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTimeToggle(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Categories',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: _categoryData.length,
                itemBuilder: (context, index) {
                  String key = _categoryData.keys.elementAt(index);
                  var data = _categoryData[key];
                  return Card(
                    color: AppColors.secondary,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        getIconData(data['categoryIcon']),
                        color: AppColors.primary,
                      ),
                      title: Text(
                        key,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${data['totalCount']} transactions',
                        style: TextStyle(color: Colors.grey[850]),
                      ),
                      trailing: Text(
                        '-₪${data['totalAmount'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeToggle() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton('Weekly', !_isWeekly),
            const SizedBox(width: 8), // Spacing between buttons
            _buildToggleButton('Monthly', _isWeekly),
          ],
        ),
      );

  Widget _buildToggleButton(String text, bool isSelected) => GestureDetector(
        onTap: () {
          setState(() {
            _isWeekly = text == 'Weekly';
            _fetchData(); // Fetch data again when switching view
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.grey[200] : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
