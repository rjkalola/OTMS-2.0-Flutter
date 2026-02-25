import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_tabs.dart';
import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerCreateOrderHeaderView extends StatelessWidget {
  BuyerCreateOrderHeaderView({super.key});

  final controller = Get.put(CreateBuyerOrderController());

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

          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
