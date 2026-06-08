import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class StockProductsListItem extends StatelessWidget {
  static const double horizontalPadding = 16;
  static const double imageSize = 52;
  static const double imageGap = 12;
  static const double dividerIndent = horizontalPadding + imageSize;

  final ProductInfo item;
  final VoidCallback? onTap;

  const StockProductsListItem({super.key, required this.item, this.onTap});

  String _qtyText() {
    if (item.isSubQty == true) {
      final packOffQty = item.packOffQty ?? '';
      final packOffUnit = item.packOfUnit ?? '';
      if (!StringHelper.isEmptyString(packOffQty)) {
        return '$packOffQty $packOffUnit'.trim();
      }
    }
    final qty = item.qty ?? 0;
    if (qty == qty.roundToDouble()) {
      return qty.toInt().toString();
    }
    return AppUtils.formatDecimalNumber(qty);
  }

  String _subtitle() {
    final parts = <String>[];
    if (!StringHelper.isEmptyString(item.supplierCode)) {
      parts.add(item.supplierCode!);
    }
    if (!StringHelper.isEmptyString(item.uuid)) {
      parts.add(item.uuid!);
    }
    return parts.join(', ');
  }

  String _priceText() {
    final price = item.price ?? item.displayPrice ?? item.totalAmount ?? '';
    return '${item.currency ?? ''}$price';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUtils.setRectangleCornerCachedNetworkImage(
                url: item.thumbUrl ?? '',
                width: imageSize,
                height: imageSize,
                borderRadius: 6,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: imageGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextView(
                      text: item.shortName ?? '',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      maxLine: 3,
                    ),
                    if (_subtitle().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      SubtitleTextView(
                        text: _subtitle(),
                        fontSize: 13,
                        color: secondaryExtraLightTextColor_(context),
                        maxLine: 2,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TitleTextView(
                    text: _qtyText(),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: defaultAccentColor_(context),
                  ),
                  const SizedBox(height: 4),
                  SubtitleTextView(
                    text: _priceText(),
                    fontSize: 13,
                    color: secondaryExtraLightTextColor_(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
