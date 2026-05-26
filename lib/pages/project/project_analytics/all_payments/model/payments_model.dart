class Payment {
  final String address;
  final String postcode;
  final double amount;
  final DateTime date;
  final PaymentStatus status;

  const Payment({
    required this.address,
    required this.postcode,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum PaymentStatus { paid, pending, overdue }

String fmtGbp(double v) {
  final s = v % 1 == 0 ? v.toStringAsFixed(2) : v.toStringAsFixed(2);
  final parts = s.split('.');
  final buf = StringBuffer();
  for (int i = 0; i < parts[0].length; i++) {
    if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
    buf.write(parts[0][i]);
  }
  return '£${buf.toString()}.${parts[1]}';
}

String monthYear(DateTime d) {
  const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[d.month]} ${d.year}';
}

String fmtDate(DateTime d) {
  const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${d.day} ${months[d.month]} ${d.year}';
}