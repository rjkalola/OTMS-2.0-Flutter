import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/basket_summary_section.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasketHeaderView extends StatelessWidget {
  BasketHeaderView({super.key});

  final controller = Get.put(BasketController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight:  Radius.circular(28)),
      ),
      child: Column(
        children: [
          BasketSummarySection(),
        ],
      ),
    );
  }
}
