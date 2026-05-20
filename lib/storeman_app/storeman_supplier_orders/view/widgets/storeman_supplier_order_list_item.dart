import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_supplier_orders/controller/storeman_supplier_order_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class StoremanSupplierOrderListItem extends StatelessWidget {
  final controller = Get.put(StoremanSupplierOrderController());

  final OrderInfo item;
  final VoidCallback onTap;

  StoremanSupplierOrderListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    int status = item.status ?? 0;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 20,
            margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryTextView(
                        text: item.date ?? "",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 1),
                      PrimaryTextView(
                        text: [
                          if (!StringHelper.isEmptyString(item.storeName))
                            item.storeName,
                          if (!StringHelper.isEmptyString(item.supplierName))
                            item.supplierName,
                        ].join(" | "),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 1),
                      PrimaryTextView(
                        text:
                            "${'items_in_order'.tr}:  ${AppUtils.formatDecimalNumber(item.orderQty ?? 0)}",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      if (!StringHelper.isEmptyString(
                          item.approveByUserName)) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            PrimaryTextView(
                              text: "${'approved_by'.tr}:",
                              fontSize: 13,
                            ),
                            const SizedBox(width: 6),
                            UserAvtarView(
                              imageUrl: item.approveByUserImage ?? "",
                              imageSize: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: PrimaryTextView(
                                text: item.approveByUserName ?? "",
                                fontSize: 13,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (!StringHelper.isEmptyString(item.orderByName)) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            PrimaryTextView(
                              text: "${'ordered_by'.tr}:",
                              fontSize: 13,
                            ),
                            const SizedBox(width: 6),
                            UserAvtarView(
                              imageUrl: item.orderByImage ?? "",
                              imageSize: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: PrimaryTextView(
                                text: item.orderByName ?? "",
                                fontSize: 13,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryTextView(
                            text: "${'order'.tr}: ${item.orderId ?? ""}",
                            color: secondaryLightTextColor_(context),
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Visibility(
                      visible: status == AppConstants.orderStatus.received ||
                          status == AppConstants.orderStatus.processing,
                      child: PrimaryButton(
                          width: 96,
                          fontSize: 15,
                          height: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.green,
                          isFixSize: true,
                          buttonText: 'delivered'.tr,
                          onPressed: () {
                            controller.onItemClick(item.id ?? 0,
                                AppConstants.orderStatus.processing);
                          }),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: status == AppConstants.orderStatus.received,
                      child: PrimaryButton(
                          width: 96,
                          fontSize: 15,
                          height: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.orange,
                          isFixSize: true,
                          buttonText: 'proceed'.tr,
                          onPressed: () {
                            controller.onItemClick(item.id ?? 0,
                                AppConstants.orderStatus.received);
                          }),
                    )
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: !StringHelper.isEmptyString(item.statusText),
            child: Positioned(
              top: 0,
              left: 32,
              child: TextViewWithContainer(
                text: item.statusText ?? "",
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                boxColor: AppUtils.getOrderStatusColor(item.status ?? 0,
                    isStoreman: true),
                borderRadius: 11,
              ),
            ),
          )
        ],
      ),
    );
  }
}
