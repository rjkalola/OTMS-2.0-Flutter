import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_tabs.dart';
import 'package:belcka/pages/project/project_list/view/widgets/project_title.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderHeaderView extends StatelessWidget {
  BuyerOrderHeaderView({super.key});

  final controller = Get.put(BuyerOrderController());

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
          BuyerOrderTabs(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
