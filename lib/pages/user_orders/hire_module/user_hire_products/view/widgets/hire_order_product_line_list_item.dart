import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HireOrderProductLineListItem extends StatelessWidget {
  final ProductInfo item;
  final VoidCallback onListItem;
  final VoidCallback? onReturnTap;
  final bool isFromProfile;

  const HireOrderProductLineListItem(
      {super.key,
      required this.item,
      required this.onListItem,
      this.onReturnTap,
      required this.isFromProfile});

  @override
  Widget build(BuildContext context) {
    final isHired = item.orderStatus == AppConstants.hireStatus.hired;
    final isInService = item.orderStatus == AppConstants.hireStatus.inService;
    final isAvailable = item.orderStatus == AppConstants.hireStatus.available;
    final showReturn = onReturnTap != null && isHired;

    return GestureDetector(
      onTap: onListItem,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 14,
            margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: ImageUtils.setRectangleCornerCachedNetworkImage(
                    url: item.thumbUrl ?? '',
                    width: 76,
                    height: 76,
                    borderRadius: 4,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleTextView(
                                  text: item.shortName ?? '',
                                  fontSize: 14,
                                  maxLine: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                                SubtitleTextView(
                                  text: item.uuid ?? '',
                                  fontSize: 12,
                                  color: secondaryExtraLightTextColor_(context),
                                )
                              ],
                            ),
                          ),
                          if (showReturn) ...[
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: PrimaryButton(
                                isFixSize: true,
                                width: 70,
                                buttonText: 'return'.tr,
                                onPressed: onReturnTap!,
                                height: 28,
                                fontSize: 13,
                                color: Colors.orange,
                                margin: EdgeInsets.zero,
                              ),
                            ),
                          ]
                        ],
                      ),
                      if (isHired) ...[
                        if (!StringHelper.isEmptyString(
                            item.approveByUserName)) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              PrimaryTextView(
                                text: "${'approved_by'.tr}:",
                                fontSize: 13,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              UserAvtarView(
                                imageUrl: item.approveByUserImage ?? "",
                                imageSize: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: PrimaryTextView(
                                  text: item.approveByUserName ?? "",
                                  fontSize: 13,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                        ],
                        if (!StringHelper.isEmptyString(item.userName) &&
                            !isFromProfile) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              PrimaryTextView(
                                text: "${'ordered_by'.tr}:",
                                fontSize: 13,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              UserAvtarView(
                                imageUrl: item.userImage ?? "",
                                imageSize: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: PrimaryTextView(
                                  text: item.userName ?? "",
                                  fontSize: 13,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                        ],
                        if (!StringHelper.isEmptyString(item.fromDateFormate) &&
                            !StringHelper.isEmptyString(
                                item.toDateFormate)) ...[
                          const SizedBox(height: 4),
                          PrimaryTextView(
                            text:
                                "${'hire'.tr}: ${item.fromDateFormate} - ${item.toDateFormate}",
                            fontSize: 13,
                            color: secondaryLightTextColor_(context),
                          ),
                        ],
                        if (!StringHelper.isEmptyString(item.supplierName)) ...[
                          const SizedBox(height: 4),
                          PrimaryTextView(
                            text: item.supplierName ?? '',
                            fontSize: 13,
                          ),
                        ],
                      ] else if (isInService) ...[
                        if (!StringHelper.isEmptyString(item.userName)) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              PrimaryTextView(
                                text: "${'in_service_by'.tr}:",
                                fontSize: 13,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              UserAvtarView(
                                imageUrl: item.userImage ?? "",
                                imageSize: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              PrimaryTextView(
                                text: item.userName ?? "",
                                fontSize: 13,
                              )
                            ],
                          ),
                        ],
                      ]
                      // else ...[
                      //   const SizedBox(height: 4),
                      //   PrimaryTextView(
                      //     text:
                      //         "${'qty'.tr}: ${(item.availableQty ?? 0).toInt()}",
                      //     fontSize: 13,
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isAvailable && !StringHelper.isEmptyString(item.orderId))
            Align(
              alignment: Alignment.topLeft,
              child: TextViewWithContainer(
                margin: const EdgeInsets.only(left: 34, top: 0),
                text: "${'order'.tr}: #${item.orderId ?? ""}",
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 11,
                boxColor: Colors.orange,
              ),
            ),
          if (isAvailable)
            Align(
              alignment: Alignment.topLeft,
              child: TextViewWithContainer(
                margin: const EdgeInsets.only(left: 34, top: 0),
                text: 'in_stock'.tr,
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 11,
                boxColor: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}
