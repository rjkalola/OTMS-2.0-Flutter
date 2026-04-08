import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderTabs extends StatelessWidget {
  BuyerOrderTabs({super.key});

  final controller = Get.put(BuyerOrderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // physics: const BouncingScrollPhysics(),
              // clipBehavior: Clip.none,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderFilterItem(
                    title: 'request'.tr,
                    selected:
                        (controller.selectedTab.value == OrderTabType.request),
                    count: controller.requestCount,
                    useFlexible: false,
                    onTap: () {
                      controller.selectedTab.value = OrderTabType.request;
                      controller.loadData();
                    },
                  ),
                  SizedBox(width: 6),
                  HeaderFilterItem(
                    title: 'upcoming'.tr,
                    selected:
                        (controller.selectedTab.value == OrderTabType.upcoming),
                    count: controller.upcomingCount,
                    useFlexible: false,
                    onTap: () {
                      controller.selectedTab.value = OrderTabType.upcoming;
                      controller.loadData();
                    },
                  ),
                  SizedBox(width: 6),
                  HeaderFilterItem(
                    title: 'processing'.tr,
                    selected:
                        (controller.selectedTab.value == OrderTabType.proceed),
                    count: controller.proceedCount,
                    useFlexible: false,
                    onTap: () {
                      controller.selectedTab.value = OrderTabType.proceed;
                      controller.loadData();
                    },
                  ),
                  SizedBox(width: 6),
                  HeaderFilterItem(
                    title: 'delivered'.tr,
                    selected: (controller.selectedTab.value ==
                        OrderTabType.delivered),
                    count: controller.deliveredCount,
                    useFlexible: false,
                    onTap: () {
                      controller.selectedTab.value = OrderTabType.delivered;
                      controller.loadData();
                    },
                  ),
                  SizedBox(width: 6),
                  HeaderFilterItem(
                    title: 'cancelled'.tr,
                    selected: (controller.selectedTab.value ==
                        OrderTabType.cancelled),
                    count: controller.cancelledCount,
                    useFlexible: false,
                    onTap: () {
                      controller.selectedTab.value = OrderTabType.cancelled;
                      controller.loadData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
