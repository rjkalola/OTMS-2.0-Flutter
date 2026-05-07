import 'package:belcka/pages/conflicts/controller/conflicts_controller.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConflictsTabBar extends StatelessWidget {
  ConflictsTabBar({super.key});

  final controller = Get.find<ConflictsController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _tabItem(ConflictsTab.all.value, 'all'.tr, controller.allCount),
                const SizedBox(width: 6),
                _tabItem(
                    ConflictsTab.timesheet.value, 'timesheet'.tr, controller.timesheetCount),
                const SizedBox(width: 6),
                _tabItem(ConflictsTab.billing.value, 'billing'.tr, controller.billingCount),
                const SizedBox(width: 6),
                _tabItem(ConflictsTab.team.value, 'team'.tr, controller.teamCount),
                const SizedBox(width: 6),
                _tabItem(
                    ConflictsTab.healthSafety.value, "H&S", controller.healthSafetyCount),
                const SizedBox(width: 6),
                _tabItem(ConflictsTab.store.value, 'store'.tr, controller.storeCount),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabItem(String tab, String title, RxInt count) {
    return HeaderFilterItem(
      title: title,
      selected: controller.selectedTab.value == tab,
      count: count,
      useFlexible: false,
      onTap: () => controller.onTabChange(tab),
    );
  }
}
