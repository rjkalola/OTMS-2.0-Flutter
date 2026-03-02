import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoDescriptionContainer extends StatelessWidget {
  ProductInfoDescriptionContainer({super.key});

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    return TitleTextView(
      text: controller.product.value.description ?? "",
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }
}
