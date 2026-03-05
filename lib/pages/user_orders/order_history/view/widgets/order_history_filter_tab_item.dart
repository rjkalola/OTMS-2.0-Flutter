import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryFilterTabItem extends StatelessWidget {
  final String? label;
  final OrderFilter? filter;

  OrderHistoryFilterTabItem({super.key, this.label, this.filter});

  final controller = Get.find<OrderHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == filter;

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip.elevated(
          label: Text(label ?? ""),
          selected: isSelected,
          selectedColor: defaultAccentColor_(context),
          backgroundColor: backgroundColor_(context),
          showCheckmark: false,
          onSelected: (_) => controller.changeFilter(filter!),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : primaryTextColor_(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      );
    });
  }
}