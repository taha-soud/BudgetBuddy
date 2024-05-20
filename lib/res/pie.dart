import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, double>> calculateTotalSpentByCategory(String userId) async {
  final Map<String, double> totalSpentByCategory = {};

  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final category = data['category'] as String? ?? 'Unknown';
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

      print('Fetched transaction: category=$category, amount=$amount');

      if (totalSpentByCategory.containsKey(category)) {
        totalSpentByCategory[category] = totalSpentByCategory[category]! + amount;
      } else {
        totalSpentByCategory[category] = amount;
      }
    }
  } catch (e) {
    print('Error calculating total spent by category: $e');
  }

  print('Total spent by category: $totalSpentByCategory');

  return totalSpentByCategory;
}
