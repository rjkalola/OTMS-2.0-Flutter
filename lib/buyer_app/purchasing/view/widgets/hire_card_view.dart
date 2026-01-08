import 'package:belcka/buyer_app/purchasing/controller/purchasing_controller.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_text_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_value_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_title_text_widget.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HireCardView extends StatelessWidget {
  final controller = Get.put(PurchasingController());

  HireCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CardViewDashboardItem(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
          margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
          borderRadius: controller.cardRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PurchasingScreenTitleWidget(title: 'hire'.tr),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            PurchasingScreenItemTextWidget(text: 'request'.tr),
                            SizedBox(
                              height: 2,
                            ),
                            PurchasingScreenItemValueWidget(value: "1"),
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Column(
                        children: [
                          PurchasingScreenItemTextWidget(text: 'hired'.tr),
                          SizedBox(
                            height: 2,
                          ),
                          PurchasingScreenItemValueWidget(value: "4"),
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Column(
                        children: [
                          PurchasingScreenItemTextWidget(text: 'available'.tr),
                          SizedBox(
                            height: 2,
                          ),
                          PurchasingScreenItemValueWidget(value: "14"),
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            PurchasingScreenItemTextWidget(
                                text: 'in_service'.tr),
                            SizedBox(
                              height: 2,
                            ),
                            PurchasingScreenItemValueWidget(value: "3"),
                          ],
                        ),
                      ))
                ],
              )
            ],
          )),
    );
  }
}
