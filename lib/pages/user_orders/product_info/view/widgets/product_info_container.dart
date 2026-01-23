import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_bullet_points_container.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_description_container.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_header_section.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoContainer extends StatelessWidget {
  ProductInfoContainer({super.key});

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductInfoHeaderSection(),
            SizedBox(height: 16),
            ProductInfoDescriptionContainer(),
            SizedBox(height: 16),
            ProductInfoBulletPointsContainer(),
          ],
        ),
      ),
    );
  }
}