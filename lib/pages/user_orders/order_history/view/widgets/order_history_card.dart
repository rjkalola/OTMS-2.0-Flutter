import 'package:belcka/pages/user_orders/order_history/view/widgets/order_progress.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final int statusIndex;
  final String lastLabel;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.statusIndex,
    required this.lastLabel,
  });

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OrdersTitleTextView(
                  text:"Order: $orderId",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  maxLine: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12,),
              OrdersTitleTextView(
                text: "03 Sep 2025",
                fontSize: 15,
                color:Colors.grey.shade600,
              )
            ],
          ),
          SizedBox(height: 4),
          OrdersTitleTextView(
            text:"Total Amount: £3200459340539.00",
            fontSize: 15,
          ),
          SizedBox(height: 14),
          OrderProgress(
            activeIndex: statusIndex,
            lastLabel: lastLabel,
          )
        ],
      ),
    );
  }
}