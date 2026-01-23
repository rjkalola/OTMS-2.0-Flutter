import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/product_details/view/widgets/product_details_header_view.dart';
import 'package:belcka/pages/user_orders/product_details/view/widgets/product_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsContainer extends StatelessWidget {
  ProductDetailsContainer({super.key});

  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductDetailsHeaderView(),
        ProductDetailsWidget()
      ],
    );
  }
}