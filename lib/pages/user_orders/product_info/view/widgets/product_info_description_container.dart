import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoDescriptionContainer extends StatelessWidget {
  ProductInfoDescriptionContainer({super.key});

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    return OrdersTitleTextView(
      text: 'A replacement pan for the Twyford Alcona close coupled toilet. '
          'manufactured from vitreous China with a horizontal waste outlet.'
          'A replacement pan for the Twyford Alcona close coupled toilet. '
          'manufactured from vitreous China with a horizontal waste outlet.',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
  }
}
