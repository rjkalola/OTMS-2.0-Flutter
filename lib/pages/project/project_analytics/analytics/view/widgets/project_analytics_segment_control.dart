import 'dart:io';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:belcka/pages/project/project_analytics/analytics/controller/project_analytics_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectAnalyticsSegmentControl extends StatelessWidget {
  ProjectAnalyticsSegmentControl({super.key});

  final controller = Get.put(ProjectAnalyticsController());

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid){
      return Obx(() =>
          CardViewDashboardItem(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: EdgeInsets.all(2),
              borderRadius: 45,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CardViewDashboardItem(
                        boxColor: controller.selectedPaymentTab.value == 0
                            ? null
                            : Colors.transparent,
                        borderColor: controller.selectedPaymentTab.value == 0
                            ? null
                            : Colors.transparent,
                        blur: controller.selectedPaymentTab.value == 0 ? null : 0,
                        boxShadow:
                        controller.selectedPaymentTab.value == 0 ? null : [],
                        child: TextViewWithContainer(
                          height: 38,
                          text: 'received'.tr,
                          fontColor: controller.selectedPaymentTab.value == 0
                              ? primaryTextColor_(context)
                              : secondaryLightTextColor_(context),
                          fontWeight: controller.selectedPaymentTab.value == 0
                              ? FontWeight.w600
                              : FontWeight.w400,
                          alignment: Alignment.center,
                          onTap: () {
                            controller.selectedPaymentTab.value = 0;
                            controller
                                .onItemTapped(controller.selectedPaymentTab.value);
                          },
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CardViewDashboardItem(
                        boxColor: controller.selectedPaymentTab.value == 1
                            ? null
                            : Colors.transparent,
                        borderColor: controller.selectedPaymentTab.value == 1
                            ? null
                            : Colors.transparent,
                        blur: controller.selectedPaymentTab.value == 1 ? null : 0,
                        boxShadow:
                        controller.selectedPaymentTab.value == 1 ? null : [],
                        child: TextViewWithContainer(
                          height: 38,
                          text:'invoiced'.tr,
                          fontColor: controller.selectedPaymentTab.value == 1
                              ? primaryTextColor_(context)
                              : secondaryLightTextColor_(context),
                          fontWeight: controller.selectedPaymentTab.value == 1
                              ? FontWeight.w600
                              : FontWeight.w400,
                          alignment: Alignment.center,
                          onTap: () {
                            controller.selectedPaymentTab.value = 1;
                            controller
                                .onItemTapped(controller.selectedPaymentTab.value);
                          },
                        ),
                      )),
                ],
              )));
    }
    else{
      return Obx(() => Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: EdgeInsets.all(2),
        height: 50,
        child: AdaptiveSegmentedControl(
          labels: [
            'received'.tr,
            'invoiced'.tr,
          ],
          selectedIndex: controller.selectedPaymentTab.value,
          onValueChanged: (index) {
            controller.selectedPaymentTab.value = index;
            controller.onItemTapped(index);
          },
        ),
      ));
    }
  }
}
