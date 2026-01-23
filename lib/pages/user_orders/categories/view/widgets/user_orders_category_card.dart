import 'package:belcka/pages/user_orders/categories/model/category_item_model.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';

class UserOrdersCategoryCard extends StatelessWidget {
  final CategoryItem item;
  const UserOrdersCategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 50,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: OrdersTitleTextView(
              text: item.title,
              textAlign: TextAlign.center,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              maxLine: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}