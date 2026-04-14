import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderIncompleteProductItem extends StatelessWidget {
  final ProductInfo item;

  const BuyerOrderIncompleteProductItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageUtils.setRectangleCornerCachedNetworkImage(
            url: item.thumbUrl ?? item.imageUrl ?? "",
            width: 74,
            height: 74,
            borderRadius: 4,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleTextView(
                  text: item.shortName ?? item.name ?? "-",
                  fontSize: 15,
                  maxLine: 2,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 2),
                SubtitleTextView(
                  text: item.uuid ?? "",
                  fontSize: 13,
                  color: secondaryExtraLightTextColor_(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TitleTextView(
                        text: "${'ordered'.tr}: ${(item.qty ?? 0).toInt()}",
                        fontSize: 13,
                        color: primaryTextColor_(context),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        color: secondaryExtraLightTextColor_(context),
                      ),
                      TitleTextView(
                        text: "${'delivered'.tr}: ${item.deliveredQty ?? 0}",
                        fontSize: 13,
                        color: primaryTextColor_(context),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        color: secondaryExtraLightTextColor_(context),
                      ),
                      TitleTextView(
                        text: "${'cancelled'.tr}: ${item.cancelledQty ?? 0}",
                        fontSize: 13,
                        color: primaryTextColor_(context),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
