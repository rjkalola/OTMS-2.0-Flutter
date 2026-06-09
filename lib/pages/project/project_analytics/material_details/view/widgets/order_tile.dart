import 'package:belcka/pages/project/project_analytics/all_payments/model/payments_model.dart';
import 'package:belcka/pages/project/project_analytics/material_details/model/material_model.dart';
import 'package:belcka/pages/project/project_analytics/material_details/view/widgets/detail_stat.dart';
import 'package:flutter/material.dart';


class OrderTile extends StatefulWidget {
  final MaterialOrder order;
  const OrderTile({required this.order});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.order.status) {
      case OrderStatus.completed: return const Color(0xFF22C55E);
      case OrderStatus.returned: return const Color(0xFFF97316);
      case OrderStatus.cancelled: return const Color(0xFFEF4444);
      case OrderStatus.pending: return const Color(0xFF6366F1);
    }
  }

  String get _statusLabel {
    switch (widget.order.status) {
      case OrderStatus.completed: return 'Completed';
      case OrderStatus.returned: return 'Returned';
      case OrderStatus.cancelled: return 'Cancelled';
      case OrderStatus.pending: return 'Pending';
    }
  }

  IconData get _statusIcon {
    switch (widget.order.status) {
      case OrderStatus.completed: return Icons.check_circle_rounded;
      case OrderStatus.returned: return Icons.keyboard_return_rounded;
      case OrderStatus.cancelled: return Icons.cancel_rounded;
      case OrderStatus.pending: return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _expanded ? _statusColor.withOpacity(0.4) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _expanded
                  ? _statusColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _expanded ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: status badge + items count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _statusColor.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 11, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(_statusLabel,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                // Items fraction
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_rounded, size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text('${o.itemsDelivered}/${o.itemsTotal}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Order ID + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order: ${o.orderId}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.2)),
                Text(fmtDate(o.date),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            // Divider
            Divider(color: Colors.grey[100], height: 1),
            const SizedBox(height: 8),
            // Amount + address + user
            Row(
              children: [
                // Left: amount + address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.payments_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 5),
                          Text(fmtGbp(o.amount),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(o.address,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _statusColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: _statusColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right: user
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('User', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(o.user,
                            style: TextStyle(
                                fontSize: 12,
                                color: _statusColor,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              o.user.split(' ').map((w) => w[0]).take(2).join(),
                              style: TextStyle(fontSize: 9, color: _statusColor, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Expanded detail
            if (_expanded) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.grey[100], height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: DetailStat(label: 'Order ID', value: o.orderId, color: _statusColor)),
                  Expanded(child: DetailStat(label: 'Items', value: '${o.itemsDelivered}/${o.itemsTotal}', color: _statusColor)),
                  Expanded(child: DetailStat(label: 'Amount', value: fmtGbp(o.amount), color: _statusColor)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 13, color: _statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusNote(o.status),
                        style: TextStyle(fontSize: 11, color: _statusColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _statusNote(OrderStatus s) {
    switch (s) {
      case OrderStatus.completed: return 'All items delivered and confirmed.';
      case OrderStatus.returned: return 'Items were returned to supplier.';
      case OrderStatus.cancelled: return 'Order was cancelled before delivery.';
      case OrderStatus.pending: return 'Awaiting delivery confirmation.';
    }
  }
}