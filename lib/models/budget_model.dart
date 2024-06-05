class Budget {
  final String id;
  final String budgetName;
  final String note;
  final DateTime fromDate;
  final DateTime toDate;
  final double totalRemaining;
  final double totalBudget;

  Budget({
    required this.budgetName,
    required this.note,
    required this.id,
    required this.fromDate,
    required this.toDate,
    required this.totalRemaining,
    required this.totalBudget,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'budgetName': budgetName,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'totalRemaining': totalRemaining,
      'totalBudget': totalBudget,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] ??
          '', // Provide a default value or handle null case appropriately
      note: json['note'] ??
          '', // Provide a default value or handle null case appropriately
      budgetName: json['budgetName'] ??
          '', // Provide a default value or handle null case appropriately
      fromDate: DateTime.parse(json['fromDate'] ??
          ''), // Provide a default value or handle null case appropriately
      toDate: DateTime.parse(json['toDate'] ??
          ''), // Provide a default value or handle null case appropriately
      totalRemaining: (json['totalRemaining'] ?? 0)
          .toDouble(), // Handle null or non-numeric values
      totalBudget: (json['totalBudget'] ?? 0)
          .toDouble(), // Handle null or non-numeric values
    );
  }
}
