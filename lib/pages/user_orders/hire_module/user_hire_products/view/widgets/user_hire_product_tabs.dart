import 'package:belcka/pages/user_orders/hire_module/user_hire_products/controller/user_hire_product_controller.dart';
import 'package:belcka/utils/enums/hire_user_product_status.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHireProductTabs extends StatelessWidget {
  UserHireProductTabs({super.key});

  final controller = Get.find<UserHireProductController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              HeaderFilterItem(
                title: 'available'.tr,
                selected: controller.selectedTab.value ==
                    HireUserProductStatus.available,
                count: controller.availableCount,
                useFlexible: false,
                onTap: () {
                  controller.selectedTab.value =
                      HireUserProductStatus.available;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'request'.tr,
                selected: controller.selectedTab.value ==
                    HireUserProductStatus.request,
                count: controller.requestCount,
                useFlexible: false,
                onTap: () {
                  controller.selectedTab.value = HireUserProductStatus.request;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'hired'.tr,
                selected:
                    controller.selectedTab.value == HireUserProductStatus.hired,
                count: controller.hiredCount,
                useFlexible: false,
                onTap: () {
                  controller.selectedTab.value = HireUserProductStatus.hired;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'in_service'.tr,
                selected: controller.selectedTab.value ==
                    HireUserProductStatus.inService,
                count: controller.inServiceCount,
                useFlexible: false,
                onTap: () {
                  controller.selectedTab.value =
                      HireUserProductStatus.inService;
                  controller.loadData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
