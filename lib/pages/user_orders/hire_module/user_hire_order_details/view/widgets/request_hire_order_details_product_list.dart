import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class RequestHireOrderDetailsProductList extends StatelessWidget {
  final List<ProductInfo> products;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final void Function(int index, bool? value) onToggleProduct;

  const RequestHireOrderDetailsProductList({
    super.key,
    required this.products,
    required this.onToggleProduct,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: NoDataFoundWidget());
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: shrinkWrap,
        physics: physics ?? const ClampingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = products[index];
          return CardViewDashboardItem(
            borderRadius: 12,
            margin: const EdgeInsets.fromLTRB(14, 2, 14, 2),
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onToggleProduct(
                index,
                !(item.isCheck ?? false),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ImageUtils.setRectangleCornerCachedNetworkImage(
                      url: item.thumbUrl ?? '',
                      width: 80,
                      height: 80,
                      borderRadius: 4,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
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
                          TitleTextView(
                            text: item.supplierName ?? '',
                            fontSize: 14,
                            color: secondaryExtraLightTextColor_(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomCheckbox(
                    mValue: item.isCheck ?? false,
                    onValueChange: (value) => onToggleProduct(index, value),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
