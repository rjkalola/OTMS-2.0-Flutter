import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditStockHeader extends StatelessWidget {
  final ProductInfo product;

  const EditStockHeader({super.key, required this.product});

  String _qtyText() {
    final qtyText = AppUtils.formatDecimalNumber(product.qty ?? 0);
    if (product.isSubQty == true) {
      final packOffQty = product.packOffQty ?? '';
      final packOffUnit = product.packOfUnit ?? '';
      return '$qtyText ($packOffQty $packOffUnit)'.trim();
    }
    return qtyText;
  }

  String _subtitle() {
    final parts = <String>[];
    if (!StringHelper.isEmptyString(product.supplierCode)) {
      parts.add(product.supplierCode!);
    }
    if (!StringHelper.isEmptyString(product.uuid)) {
      parts.add(product.uuid!);
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUtils.setRectangleCornerCachedNetworkImage(
                url: product.thumbUrl ?? '',
                width: 56,
                height: 56,
                borderRadius: 6,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextView(
                      text: product.shortName ?? '',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      maxLine: 3,
                    ),
                    if (_subtitle().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SubtitleTextView(
                              text: _subtitle(),
                              fontSize: 13,
                              color: secondaryExtraLightTextColor_(context),
                              maxLine: 2,
                            ),
                          ),
                          SubtitleTextView(
                            text:
                                '${product.currency ?? ''}${product.price ?? product.totalAmount ?? ''}',
                            fontSize: 13,
                            color: primaryTextColor_(context),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: dividerColor_(context)),
          const SizedBox(height: 10),
          Row(
            children: [
              SubtitleTextView(
                text: '${'qty_in_stock'.tr}:',
                fontSize: 14,
                color: secondaryExtraLightTextColor_(context),
              ),
              const Spacer(),
              TitleTextView(
                text: _qtyText(),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: primaryTextColor_(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
