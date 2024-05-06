class Budget {
  final String id;
  final DateTime fromDate;
  final DateTime toDate;
  final double totalRemaining;
  final double totalBudget;

  Budget({
    required this.id,
    required this.fromDate,
    required this.toDate,
    required this.totalRemaining,
    required this.totalBudget,
  });
}
