import 'package:belcka/pages/user_orders/product_set/controller/product_set_controller.dart';
import 'package:belcka/pages/user_orders/product_set/view/widgets/product_set_item_list.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSetContainer extends StatelessWidget {
  ProductSetContainer({super.key});

  final controller = Get.put(ProductSetController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 7,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Icon(Icons.add_rounded, color: Colors.blueAccent, size: 32),
          ),
        ),
        itemBuilder: (_, __) =>  ProductSetItemList(),
      ),
    );
  }
}
