import 'dart:ui';

enum FilterPeriod { all, week, month, custom }

class LaborEntry {
  final String name;
  final String role;
  final double amount;
  final double hours;
  final String avatarInitials;
  final Color avatarColor;

  const LaborEntry({
    required this.name,
    required this.role,
    required this.amount,
    required this.hours,
    required this.avatarInitials,
    required this.avatarColor,
  });

  double get hourlyRate => hours > 0 ? amount / hours : 0;
}

String fmtGbp(double v, {int decimals = 2}) {
  final s = v.toStringAsFixed(decimals);
  final parts = s.split('.');
  final buf = StringBuffer();
  for (int i = 0; i < parts[0].length; i++) {
    if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
    buf.write(parts[0][i]);
  }
  return decimals > 0
      ? '£${buf.toString()}.${parts[1]}'
      : '£${buf.toString()}';
}