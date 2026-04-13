import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String _hireDisplayFrom(HireOrderInfo item) {
  if (!StringHelper.isEmptyString(item.fromDateFormate)) {
    return item.fromDateFormate!;
  }
  return item.fromDate ?? '';
}

String _hireDisplayTo(HireOrderInfo item) {
  if (!StringHelper.isEmptyString(item.toDateFormate)) {
    return item.toDateFormate!;
  }
  return item.toDate ?? '';
}

Color? hireStatusColorFromHex(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var h = hex.trim();
  if (h.startsWith('#')) {
    h = h.substring(1);
  }
  if (h.length == 6) {
    h = 'FF$h';
  }
  try {
    return Color(int.parse(h, radix: 16));
  } catch (_) {
    return null;
  }
}

class HireOrderListItem extends StatelessWidget {
  final HireOrderInfo item;
  final VoidCallback onListItem;

  const HireOrderListItem({
    super.key,
    required this.item,
    required this.onListItem,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = hireStatusColorFromHex(item.statusColor) ??
        AppUtils.getHireStatusColor(item.status ?? 0);

    return GestureDetector(
      onTap: onListItem,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 14,
            margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryTextView(
                      text: item.date ?? '',
                      fontSize: 14,
                    ),
                    PrimaryTextView(
                      text: "${'order'.tr}: ${item.orderId ?? ''}",
                      color: secondaryLightTextColor_(context),
                      fontSize: 13,
                    )
                  ],
                ),
                const SizedBox(height: 2),
                PrimaryTextView(
                  text: [
                    if (!StringHelper.isEmptyString(item.companyName))
                      item.companyName!,
                    // if (!StringHelper.isEmptyString(item.userName))
                    //   "${'ordered_by'.tr}: ${item.userName!}",
                  ].join(' | '),
                  fontSize: 15,
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: primaryTextColor_(context),
                      fontSize: 14,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(
                        text: '${'hire_from'.tr}: ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: _hireDisplayFrom(item),
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: ' | ${'hire_to'.tr}: ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: _hireDisplayTo(item),
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                if (item.products != null && item.products!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  PrimaryTextView(
                    text: "${'ordered_items'.tr}: ${item.products!.length}",
                    fontSize: 14,
                    color: secondaryLightTextColor_(context),
                  ),
                ],
              ],
            ),
          ),
          Visibility(
            visible: !StringHelper.isEmptyString(item.statusText),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextViewWithContainer(
                margin: const EdgeInsets.only(left: 34, top: 0),
                text: item.statusText ?? '',
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 11,
                boxColor: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
