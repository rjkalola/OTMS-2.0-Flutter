import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class EditStockDetails extends StatelessWidget {
  final ProductInfo product;

  const EditStockDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final sections = <String>[];
    if (!StringHelper.isEmptyString(product.productCategories)) {
      sections.add(product.productCategories!);
    }
    if (!StringHelper.isEmptyString(product.supplierName)) {
      sections.add(product.supplierName!);
    }
    if (!StringHelper.isEmptyString(product.description)) {
      sections.add(product.description!);
    }

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          for (int i = 0; i < sections.length; i++) ...[
            if (i > 0) Divider(height: 1, color: dividerColor_(context)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TitleTextView(
                  text: sections[i],
                  fontSize: 15,
                  fontWeight: i == sections.length - 1 &&
                          !StringHelper.isEmptyString(product.description) &&
                          sections[i] == product.description
                      ? FontWeight.w400
                      : FontWeight.w600,
                  maxLine: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
