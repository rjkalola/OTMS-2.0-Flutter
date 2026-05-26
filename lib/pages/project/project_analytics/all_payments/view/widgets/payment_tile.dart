import 'package:belcka/pages/project/project_analytics/all_payments/model/payments_model.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart' hide fmtGbp;
import 'package:flutter/material.dart';

class PaymentTile extends StatefulWidget {
  final Payment payment;
  final bool incVat;

  const PaymentTile({required this.payment, required this.incVat});

  @override
  State<PaymentTile> createState() => _PaymentTileState();
}

class _PaymentTileState extends State<PaymentTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.payment;
    final amount = widget.incVat ? p.amount * 1.2 : p.amount;
    final statusColor = _statusColor(p.status);
    final statusLabel = _statusLabel(p.status);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Address icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.home_work_rounded,
                      size: 20, color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.address,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(p.postcode,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fmtGbp(amount),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                          letterSpacing: -0.3),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(statusLabel,
                          style: TextStyle(
                              fontSize: 10,
                              color: statusColor,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.grey[100]),
              const SizedBox(height: 8),
              _InfoRow(
                  label: 'Date',
                  value: fmtDate(p.date)),
              const SizedBox(height: 4),
              _InfoRow(
                  label: 'Net Amount',
                  value: fmtGbp(p.amount)),
              if (widget.incVat) ...[
                const SizedBox(height: 4),
                _InfoRow(
                    label: 'VAT (20%)',
                    value: fmtGbp(p.amount * 0.2),
                    valueColor: const Color(0xFF94A3B8)),
                const SizedBox(height: 4),
                _InfoRow(
                    label: 'Total Inc. VAT',
                    value: fmtGbp(p.amount * 1.2),
                    valueColor: statusColor),
              ],
              const SizedBox(height: 4),
              _InfoRow(label: 'Reference', value: '#REF-${p.postcode.replaceAll(' ', '')}'),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.paid:
        return const Color(0xFF22C55E);
      case PaymentStatus.pending:
        return const Color(0xFFF59E0B);
      case PaymentStatus.overdue:
        return const Color(0xFFEF4444);
    }
  }

  String _statusLabel(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.overdue:
        return 'Overdue';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF0F172A))),
      ],
    );
  }
}