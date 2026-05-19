import 'package:belcka/pages/project/project_analytics/model/project_analytics_model.dart';
import 'package:flutter/material.dart';

class PaymentRow extends StatelessWidget {
  final Payment payment;
  const PaymentRow({required this.payment});

  @override
  Widget build(BuildContext context) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${payment.date.day} ${months[payment.date.month]} ${payment.date.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_work_rounded,
                size: 18, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.address,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${payment.postcode} · $dateStr',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '£${(payment.amount / 1000).toStringAsFixed(0)}k',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF22C55E)),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Paid',
                    style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}