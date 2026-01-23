import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoBulletPointsContainer extends StatelessWidget {
  ProductInfoBulletPointsContainer({super.key});

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    final points = [
      'Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately Cistern and seat sold separately',
      'EN997-CLASS 2',
      '25 Years guarantee',
      'Quality product',
      'Co-ordinating alcona range',
      'Achieves an environmentally friendly 4/2.6 litre dual flush',
      'Cistern and seat sold separately',
      'EN997-CLASS 2',
      '25 Years guarantee',
      'Quality product',
      'Co-ordinating alcona range',
      'Achieves an environmentally friendly 4/2.6 litre dual flush',
      'Cistern and seat sold separately',
      'EN997-CLASS 2',
      '25 Years guarantee',
      'Quality product',
      'Co-ordinating alcona range',
      'Achieves an environmentally friendly 4/2.6 litre dual flush',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((text) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OrdersTitleTextView(
                  text: '• ',
                  fontSize: 20),
              Expanded(
                child: OrdersTitleTextView(
                  text:text,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,)
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}