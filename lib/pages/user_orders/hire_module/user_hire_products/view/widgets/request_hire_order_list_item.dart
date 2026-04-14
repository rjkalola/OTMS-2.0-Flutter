import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String _requestHireDisplayFrom(HireOrderInfo item) {
  if (item.fromDateFormate != null && item.fromDateFormate!.isNotEmpty) {
    return item.fromDateFormate!;
  }
  return item.fromDate ?? '';
}

String _requestHireDisplayTo(HireOrderInfo item) {
  if (item.toDateFormate != null && item.toDateFormate!.isNotEmpty) {
    return item.toDateFormate!;
  }
  return item.toDate ?? '';
}

class RequestHireOrderListItem extends StatelessWidget {
  final HireOrderInfo item;
  final int orderListIndex;
  final VoidCallback onListItem;
  final void Function(int orderListIndex, int productIndex) onApproveProduct;
  final void Function(int orderListIndex, int productIndex) onCancelProduct;

  final bool showApproveButton, isFromProfile;

  const RequestHireOrderListItem(
      {super.key,
      required this.item,
      required this.orderListIndex,
      required this.onListItem,
      required this.onApproveProduct,
      required this.onCancelProduct,
      this.showApproveButton = true,
      required this.isFromProfile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 14,
            margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(
                    //   child: PrimaryTextView(
                    //     text: item.companyName ?? '',
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w500,
                    //     maxLine: 1,
                    //   ),
                    // ),
                    // const SizedBox(width: 10),
                    if (!isFromProfile)
                      PrimaryTextView(
                        text: !StringHelper.isEmptyString(item.userName)
                            ? "${'ordered_by'.tr}: ${item.userName}"
                            : '',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.end,
                        maxLine: 2,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                PrimaryTextView(
                  text:
                      "${'hire'.tr}: ${_requestHireDisplayFrom(item)} - ${_requestHireDisplayTo(item)}",
                  fontSize: 14,
                  color: secondaryLightTextColor_(context),
                ),
                const SizedBox(height: 1),
                PrimaryTextView(
                  text: "${'order_date'.tr}: ${item.date ?? ''}",
                  fontSize: 14,
                  color: secondaryLightTextColor_(context),
                ),
                if (item.products != null && item.products!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...List.generate(item.products!.length, (index) {
                    final product = item.products![index];
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: AppUtils.onHireProductImageItem(
                                  productId: product.productId ?? 0),
                              child: ImageUtils
                                  .setRectangleCornerCachedNetworkImage(
                                url: product.thumbUrl ?? '',
                                width: 72,
                                height: 72,
                                borderRadius: 4,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextView(
                                    text: product.shortName ?? '',
                                    fontSize: 14,
                                    maxLine: 2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SubtitleTextView(
                                    text: product.uuid ?? '',
                                    fontSize: 12,
                                    color:
                                        secondaryExtraLightTextColor_(context),
                                  ),
                                  showApproveButton
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: PrimaryButton(
                                                buttonText: 'cancel'.tr,
                                                onPressed: () =>
                                                    onCancelProduct(
                                                  orderListIndex,
                                                  index,
                                                ),
                                                height: 32,
                                                fontSize: 13,
                                                color: Colors.red,
                                                margin: EdgeInsets.zero,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: PrimaryButton(
                                                buttonText: 'approve'.tr,
                                                onPressed: () =>
                                                    onApproveProduct(
                                                  orderListIndex,
                                                  index,
                                                ),
                                                height: 32,
                                                fontSize: 13,
                                                color: Colors.green,
                                                margin: EdgeInsets.zero,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: PrimaryButton(
                                                buttonText: 'cancel'.tr,
                                                onPressed: () =>
                                                    onCancelProduct(
                                                  orderListIndex,
                                                  index,
                                                ),
                                                height: 32,
                                                fontSize: 13,
                                                color: Colors.red,
                                                margin: EdgeInsets.zero,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (index != item.products!.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              height: 1,
                              color: dividerColor_(context),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: TextViewWithContainer(
              margin: const EdgeInsets.only(left: 34, top: 0),
              text: "${'order'.tr}: #${item.orderId ?? ''}",
              padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
              fontColor: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 11,
              boxColor: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
