import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_list/controller/notification_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';

class NotificationTabBar extends StatelessWidget {
  NotificationTabBar({super.key});

  final controller = Get.put(NotificationListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: EdgeInsets.all(6),
        decoration: AppUtils.getGrayBorderDecoration(
            color: ThemeConfig.isDarkMode
                ? AppUtils.getColor("#2D2D2D")
                : AppUtils.getColor("#D8D8D8"),
            radius: 15),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: TextViewWithContainer(
                  height: 34,
                  borderRadius: 15,
                  boxColor: controller.selectedIndex.value == 0
                      ? backgroundColor_(context)
                      : Colors.transparent,
                  text: 'feed'.tr,
                  fontColor: primaryTextColor_(context),
                  fontWeight: controller.selectedIndex.value == 0
                      ? FontWeight.w600
                      : FontWeight.w400,
                  alignment: Alignment.center,
                  onTap: () {
                    controller.selectedIndex.value = 0;
                    controller.onItemTapped(controller.selectedIndex.value);
                  },
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: TextViewWithContainer(
                  height: 34,
                  borderRadius: 15,
                  boxColor: controller.selectedIndex.value == 1
                      ? backgroundColor_(context)
                      : Colors.transparent,
                  text: controller.announcementCount.value > 0
                      ? "${'announcement'.tr} (${controller.announcementCount.value})"
                      : 'announcement'.tr,
                  fontColor: primaryTextColor_(context),
                  fontWeight: controller.selectedIndex.value == 1
                      ? FontWeight.w600
                      : FontWeight.w400,
                  alignment: Alignment.center,
                  onTap: () {
                    controller.selectedIndex.value = 1;
                    controller.onItemTapped(controller.selectedIndex.value);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
