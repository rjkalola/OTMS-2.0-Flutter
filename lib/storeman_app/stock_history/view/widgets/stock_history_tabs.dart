import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/stock_history/controller/stock_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockHistoryTabs extends StatelessWidget {
  const StockHistoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockHistoryController>();

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: dividerColor_(context)),
          ),
          child: Row(
            children: [
              _TabItem(
                title: 'all'.tr,
                selected: controller.selectedTab.value == StockHistoryTab.all,
                onTap: () => controller.onTabChanged(StockHistoryTab.all),
              ),
              _TabItem(
                title: 'stock_in'.tr,
                selected:
                    controller.selectedTab.value == StockHistoryTab.stockIn,
                onTap: () => controller.onTabChanged(StockHistoryTab.stockIn),
              ),
              _TabItem(
                title: 'stock_out'.tr,
                selected:
                    controller.selectedTab.value == StockHistoryTab.stockOut,
                onTap: () => controller.onTabChanged(StockHistoryTab.stockOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? defaultAccentColor_(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : defaultAccentColor_(context),
            ),
          ),
        ),
      ),
    );
  }
}
