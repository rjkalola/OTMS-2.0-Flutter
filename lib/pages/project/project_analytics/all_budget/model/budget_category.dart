import 'dart:ui';

class BudgetCategory {
  final String name;
  final double total;
  final double spent;
  final Color color;

  const BudgetCategory({
    required this.name,
    required this.total,
    required this.spent,
    required this.color,
  });

  double get remaining => total - spent;
  bool get isOverspent => spent > total;
  double get progress => (spent / total).clamp(0.0, 1.0);
}