import 'dart:ui';

class BudgetItem {
  final String label;
  final double amount;
  final double spent;
  final Color color;
  final bool overspent;
  final double? overspentBy;

  const BudgetItem({
    required this.label,
    required this.amount,
    required this.spent,
    required this.color,
    this.overspent = false,
    this.overspentBy,
  });
}

class Payment {
  final String address;
  final String postcode;
  final double amount;
  final DateTime date;

  const Payment({
    required this.address,
    required this.postcode,
    required this.amount,
    required this.date,
  });
}