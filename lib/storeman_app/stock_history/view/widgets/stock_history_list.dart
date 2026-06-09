import 'package:belcka/storeman_app/stock_history/controller/stock_history_controller.dart';
import 'package:belcka/storeman_app/stock_history/view/widgets/stock_history_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockHistoryList extends StatelessWidget {
  const StockHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockHistoryController>();

    return Obx(
      () => controller.filteredItems.isEmpty
          ? const Center(child: NoDataFoundWidget())
          : ListView.separated(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              itemCount: controller.filteredItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return StockHistoryListItem(
                  item: controller.filteredItems[index],
                );
              },
            ),
    );
  }
}
