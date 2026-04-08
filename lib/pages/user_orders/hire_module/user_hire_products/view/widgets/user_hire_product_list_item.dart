import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/controller/user_hire_product_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHireProductListItem extends StatelessWidget {
  final ProductInfo item;
  final VoidCallback onListItem;
  final VoidCallback onProductImageItem;
  final bool isCartButtonVisible;

  UserHireProductListItem({
    super.key,
    required this.item,
    required this.onListItem,
    required this.onProductImageItem,
    required this.isCartButtonVisible
  });

  @override
  Widget build(BuildContext context) {
    final isInCart = item.isCheck == true;

    return GestureDetector(
      onTap: onListItem,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 12,
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 5),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: ImageUtils.setRectangleCornerCachedNetworkImage(
                        url: item.thumbUrl ?? '',
                        width: 80,
                        height: 80,
                        borderRadius: 4,
                        fit: BoxFit.contain,
                      ),

                      onTap: onProductImageItem,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextView(
                            text: item.shortName ?? '',
                            fontSize: 15,
                            maxLine: 2,
                            fontWeight: FontWeight.w500,
                          ),
                          SubtitleTextView(
                            text: item.uuid ?? '',
                            fontSize: 13,
                            color: secondaryExtraLightTextColor_(context),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TitleTextView(
                                  text: item.supplierName ?? "",
                                  fontSize: 15,
                                ),
                              ),
                              Visibility(
                                visible: isCartButtonVisible,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    backgroundColor:
                                        isInCart ? Colors.red : Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    item.isCheck = !isInCart;
                                    Get.find<UserHireProductController>()
                                        .notifyProductItemChanged();
                                  },
                                  icon: isInCart
                                      ? ImageUtils.setSvgAssetsImage(
                                          path: Drawable.deleteIcon,
                                          width: 13,
                                          height: 13,
                                          color: Colors.white,
                                        )
                                      : CartIconWidget(
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                  label: Text(
                                    isInCart ? 'remove'.tr : 'add_to_cart'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: !StringHelper.isEmptyString(item.stockStatus ?? ''),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextViewWithContainer(
                margin: const EdgeInsets.only(left: 34, top: 0),
                text: item.stockStatus ?? '',
                padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                boxColor: AppUtils.getProductStockStatusColor(
                  item.stockStatusId ?? 0,
                ),
                // borderRadius: 5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
