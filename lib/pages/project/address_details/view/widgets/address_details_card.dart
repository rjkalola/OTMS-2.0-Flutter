import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_filter_list.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_info_row.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressDetailsCard extends StatelessWidget {
  final controller = Get.put(AddressDetailsController());

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Completed':
          return Colors.green;
        case 'In Progress':
          return Colors.orange;
        case 'Pending':
          return Colors.grey;
        default:
          return primaryTextColor_(context);
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(26, 0, 26, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryTextView(
                  text: controller.addressDetailsInfo?.name ?? "",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 8,
                ),
                AddressDetailsInfoRow(
                    label: "${'start_date'.tr}:",
                    value: controller.addressDetailsInfo?.startDate ?? ""),
                AddressDetailsInfoRow(
                    label: "${'end_date'.tr}:",
                    value: controller.addressDetailsInfo?.endDate ?? ""),
                AddressDetailsInfoRow(
                    label: "${'status'.tr}:",
                    value: controller.addressDetailsInfo?.statusText ?? "",
                    valueColor: getStatusColor(
                        controller.addressDetailsInfo?.statusText ?? "")),
              ],
            ),
          ),
          AddressDetailsFilterList()
        ],
      ),
    );
  }
}
