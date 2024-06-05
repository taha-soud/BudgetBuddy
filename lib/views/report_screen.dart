import 'package:flutter/material.dart';
import '../res/custom_color.dart';
import '../utils/icons.dart';  // Utility to fetch icon data
import '../view_models/report_viewmodel.dart';
import 'home_screen.dart';  // Your ViewModel

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
          onPressed: () => {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          )}
        ),
        title: const Text("Report", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Spacer(),
          _buildTimeToggle(),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Categories', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categoryData.length,
              itemBuilder: (context, index) {
                String key = _categoryData.keys.elementAt(index);
                var data = _categoryData[key];
                return Card(
                  color: AppColors.secondary, // Assuming secondary is a lighter shade suitable for card background
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: Icon(getIconData(data['categoryIcon']), color: AppColors.primary),
                    title: Text(key, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    subtitle: Text('${data['totalCount']} transactions', style: TextStyle(color: Colors.grey[850])),
                    trailing: Text('-₪${data['totalAmount'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 16)),
                  ),
                );
              },
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
        _buildToggleButton('Weekly', _isWeekly),
        const SizedBox(width: 8), // Spacing between buttons
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
