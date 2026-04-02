import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/view/widgets/hire_order_list_item.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHireOrderDetailsHeader extends StatelessWidget {
  final HireOrderInfo item;
  final VoidCallback onListItem;

  const UserHireOrderDetailsHeader({
    super.key,
    required this.item,
    required this.onListItem,
  });

  String _hireFromDisplay() {
    if (item.fromDateFormate != null && item.fromDateFormate!.isNotEmpty) {
      return item.fromDateFormate!;
    }
    return item.fromDate ?? '';
  }

  String _hireToDisplay() {
    if (item.toDateFormate != null && item.toDateFormate!.isNotEmpty) {
      return item.toDateFormate!;
    }
    return item.toDate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = hireStatusColorFromHex(item.statusColor) ??
        AppUtils.getHireStatusColor(item.status ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: GestureDetector(
        onTap: onListItem,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextView(
                text:
                    "${'hire'.tr}: ${_hireFromDisplay()} - ${_hireToDisplay()}",
                fontSize: 14,
                color: primaryTextColor_(context),
              ),
              const SizedBox(height: 2),
              PrimaryTextView(
                text: "${'order_date'.tr}: ${item.date ?? ''}",
                fontSize: 14,
                color: primaryTextColor_(context),
              ),
              const SizedBox(height: 3),
              if (!StringHelper.isEmptyString(item.projectName)) ...[
                PrimaryTextView(
                  text: "${'project'.tr}: ${item.projectName!}",
                  fontSize: 15,
                ),
                const SizedBox(height: 3),
              ],
              if (!StringHelper.isEmptyString(item.addressName)) ...[
                PrimaryTextView(
                  text: "${'address'.tr}: ${item.addressName!}",
                  fontSize: 15,
                ),
                const SizedBox(height: 3),
              ],
              Row(
                children: [
                  PrimaryTextView(
                    text: "${'status'.tr}: ",
                    fontSize: 15,
                    color: primaryTextColor_(context),
                  ),
                  PrimaryTextView(
                    text: item.statusText ?? '',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
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
