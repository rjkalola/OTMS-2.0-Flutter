import 'package:belcka/pages/user_orders/hire_module/create_hire_order/controller/create_hire_order_controller.dart';
import 'package:belcka/pages/user_orders/hire_module/create_hire_order/view/widgets/create_hire_order_summary_section.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateHireOrderHeaderView extends StatelessWidget {
  CreateHireOrderHeaderView({super.key});

  final controller = Get.find<CreateHireOrderController>();

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
          CreateHireOrderSummarySection(),
        ],
      ),
    );
  }
}
