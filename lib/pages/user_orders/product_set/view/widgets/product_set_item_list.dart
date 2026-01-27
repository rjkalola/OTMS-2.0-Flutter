import 'package:belcka/pages/user_orders/product_set/controller/product_set_controller.dart';
import 'package:belcka/pages/user_orders/product_set/view/widgets/product_set_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSetItemList extends StatelessWidget {
  ProductSetItemList({super.key});
  final controller = Get.put(ProductSetController());

  @override
  Widget build(BuildContext context) {
    return ProductSetItem();
  }
}