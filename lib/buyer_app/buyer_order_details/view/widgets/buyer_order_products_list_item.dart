import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/buyer_order_details_controller.dart';

class BuyerOrderProductsListItem extends StatelessWidget {
  final ProductInfo item;
  final VoidCallback onListItem;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  final controller = Get.find<BuyerOrderDetailsController>();

  BuyerOrderProductsListItem({
    super.key,
    required this.item,
    required this.onListItem,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: CardViewDashboardItem(
          borderRadius: 10,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUtils.setRectangleCornerCachedNetworkImage(
                    url: item.thumbUrl ?? "",
                    width: 90,
                    height: 90,
                    borderRadius: 4,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextView(
                          text: item.shortName,
                          fontSize: 15,
                          maxLine: 2,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 4),
                        SubtitleTextView(
                          text: item.uuid ?? "",
                          fontSize: 13,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                        // const SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     OrderQuantityDisplayTextView(
                        //       value: item.qty ?? 0,
                        //       width: 52,
                        //       height: 30,
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 12),
                        TitleTextView(
                          text: "${'ordered_qty'.tr}: ${item.qty ?? 0}",
                          fontSize: 13,
                          color: primaryTextColor_(context),
                        ),
                        Row(
                          children: [
                            TitleTextView(
                              text:
                                  "${'received_qty'.tr}: ${item.receivedQty ?? 0}",
                              fontSize: 13,
                              color: primaryTextColor_(context),
                            ),
                            const Spacer(),
                            TitleTextView(
                              text:
                                  "${controller.orderInfo.value.currency ?? ""}${item.price ?? "0"}",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),

                        // TitleTextView(
                        //   text:
                        //       "${'available_qty'.tr}: ${item.availableQty ?? 0}",
                        //   fontSize: 13,
                        //   color: secondaryExtraLightTextColor_(context),
                        // ),
                        // const SizedBox(height: 3),
                        // TitleTextView(
                        //   text:
                        //       "${'expected_qty'.tr}: ${item.remainingQty ?? 0}",
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Visibility(
                visible: ((item.qty ?? 0) - (item.receivedQty ?? 0)) > 0,
                child: Column(
                  children: [
                    Divider(
                      color: dividerColor_(context),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        TitleTextView(
                          text: 'qty_to_receive'.tr,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        OrderQuantityChangeButton(text: "-", onTap: onRemove),
                        const SizedBox(width: 8),
                        OrderQuantityDisplayTextView(
                          value: (item.cartQty ?? 0).toInt(),
                          width: 52,
                          height: 30,
                        ),
                        const SizedBox(width: 8),
                        OrderQuantityChangeButton(text: "+", onTap: onAdd),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
