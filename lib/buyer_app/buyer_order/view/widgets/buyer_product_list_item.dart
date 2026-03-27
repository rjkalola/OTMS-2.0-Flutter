import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';

import '../../../../utils/string_helper.dart';
import '../../controller/buyer_order_controller.dart';
import 'package:get/get.dart';

class BuyerProductListItem extends StatelessWidget {
  final controller = Get.put(BuyerOrderController());

  final ProductInfo item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Function(int qty) onQtyTyped;
  final VoidCallback onDelete;
  final VoidCallback onListItem;

  // final FocusNode focusNode;

  BuyerProductListItem(
      {super.key,
      required this.item,
      // required this.focusNode,
      required this.onAdd,
      required this.onRemove,
      required this.onQtyTyped,
      required this.onDelete,
      required this.onListItem});

  // @override
  // State<RequestBuyerOrderListItem> createState() =>
  //     _RequestBuyerOrderListItemState();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onListItem,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Stack(
            children: [
              CardViewDashboardItem(
                borderRadius: 10,
                margin: EdgeInsets.only(top: 8),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageUtils.setRectangleCornerCachedNetworkImage(
                          url: item.thumbUrl ?? "",
                          width: 86,
                          height: 86,
                          borderRadius: 4,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextView(
                                text: item.shortName ?? "",
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
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  OrderQuantityChangeButton(
                                      text: "-", onTap: onRemove),
                                  const SizedBox(width: 8),
                                  OrderQuantityDisplayTextView(
                                    value: (item.cartQty ?? 0).toInt(),
                                    width: 52,
                                    height: 30,
                                  ),
                                  // ...existing commented code...
                                  const SizedBox(width: 8),
                                  OrderQuantityChangeButton(
                                      text: "+", onTap: onAdd),
                                  const Spacer(),
                                  TitleTextView(
                                    text: "${item.currency}${item.price}",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TitleTextView(
                                text:
                                    "Available Qty: ${AppUtils.formatDecimalNumber(item.qty ?? 0)}",
                                fontSize: 13,
                                color: secondaryExtraLightTextColor_(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!controller.isSingleFilter.value &&
                        (!StringHelper.isEmptyString(item.storeName) ||
                            !StringHelper.isEmptyString(
                                item.orderUsersDisplay)))
                      Column(
                        children: [
                          Divider(color: dividerColor_(context)),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, bottom: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: !StringHelper.isEmptyString(
                                                item.storeName) ||
                                            !StringHelper.isEmptyString(
                                                item.supplierName) ||
                                            !StringHelper.isEmptyString(
                                                item.projectName) ||
                                            !StringHelper.isEmptyString(
                                                item.productCategories),
                                        child: TitleTextView(
                                          text: [
                                            if (!StringHelper.isEmptyString(
                                                item.storeName))
                                              item.storeName,
                                            if (!StringHelper.isEmptyString(
                                                item.supplierName))
                                              item.supplierName,
                                            if (!StringHelper.isEmptyString(
                                                item.projectName))
                                              item.projectName,
                                            if (!StringHelper.isEmptyString(
                                                item.productCategories))
                                              item.productCategories,
                                          ].join(" | "),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Visibility(
                                        visible: !StringHelper.isEmptyString(
                                            item.orderUsersDisplay),
                                        child: TitleTextView(
                                          text: item.orderUsersDisplay ?? "",
                                          fontSize: 15,
                                          color: defaultAccentColor_(context),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.delete, color: Colors.red),
                              //   onPressed: onDelete,
                              // )
                            ],
                          )
                        ],
                      )
                    else
                      SizedBox(
                        height: 6,
                      ),
                  ],
                ),
              ),
              Visibility(
                visible: !StringHelper.isEmptyString(item.stockStatus ?? ""),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextViewWithContainer(
                    margin: EdgeInsets.only(right: 25, top: 0),
                    text: item.stockStatus ?? "",
                    padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    boxColor: AppUtils.getProductStockStatusColor(
                        item.stockStatusId ?? 0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
