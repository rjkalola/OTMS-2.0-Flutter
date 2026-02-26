import 'package:belcka/buyer_app/purchasing/controller/purchasing_controller.dart';
import 'package:belcka/buyer_app/purchasing/model/buyer_order_dashboard_response.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_text_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_title_text_widget.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryCardView extends StatelessWidget {
  final controller = Get.put(PurchasingController());

  InventoryCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyList(controller.inventoryData.value.inventory)
        ? SizedBox(
            width: double.infinity,
            child: CardViewDashboardItem(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
                borderRadius: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PurchasingScreenTitleWidget(title: 'inventory'.tr),
                    SizedBox(
                      height: 6,
                    ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, position) {
                          Inventory info = controller
                              .inventoryData.value.inventory![position];
                          return Row(
                            children: [
                              Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: PurchasingScreenItemTextWidget(
                                      text: info.name ?? "")),
                              Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: PurchasingScreenItemTextWidget(
                                    text: info.amount ?? "",
                                    fontSize: 14,
                                  )),
                            ],
                          );
                        },
                        itemCount:
                            controller.inventoryData.value.inventory!.length,
                        separatorBuilder: (context, position) => SizedBox(
                              height: 4,
                            ))
                    // SizedBox(
                    //   height: 6,
                    // ),
                    // Row(
                    //   children: [
                    //     Flexible(
                    //         flex: 2,
                    //         fit: FlexFit.tight,
                    //         child:
                    //             PurchasingScreenItemTextWidget(text: 'trulock'.tr)),
                    //     Flexible(
                    //         flex: 3,
                    //         fit: FlexFit.tight,
                    //         child: PurchasingScreenItemTextWidget(text: "£6208.53")),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 6,
                    // ),
                    // Row(
                    //   children: [
                    //     Flexible(
                    //         flex: 2,
                    //         fit: FlexFit.tight,
                    //         child: PurchasingScreenItemTextWidget(
                    //             text: 'camden'.tr, fontSize: 14)),
                    //     Flexible(
                    //         flex: 3,
                    //         fit: FlexFit.tight,
                    //         child: PurchasingScreenItemTextWidget(
                    //             text: "£112.43", fontSize: 14)),
                    //   ],
                    // ),
                  ],
                )),
          )
        : Container();
  }
}
