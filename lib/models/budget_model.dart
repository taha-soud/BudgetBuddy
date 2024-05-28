class Budget {
  final String id;
  final String budgetName;
  final String note;
  final DateTime fromDate;
  final DateTime toDate;
  late final double totalRemaining;
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
      id: json['id'],
      note:json['note'],
      budgetName: json['budgetName'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      totalRemaining: json['totalRemaining'],
      totalBudget: json['totalBudget'],
    );
  }
}