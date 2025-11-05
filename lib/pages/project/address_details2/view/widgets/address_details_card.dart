import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_info_row.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

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
    return CardViewDashboardItem(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddressDetailsInfoRow(label: "${'project'.tr}:", value: controller.addressDetailsInfo?.projectName ?? ""),
          AddressDetailsInfoRow(label: "${'start_date'.tr}:", value: controller.addressDetailsInfo?.startDate ?? ""),
          AddressDetailsInfoRow(label: "${'end_date'.tr}:", value: controller.addressDetailsInfo?.endDate ?? ""),
          AddressDetailsInfoRow(label: "${'status'.tr}:", value: controller.addressDetailsInfo?.statusText ?? "", valueColor: getStatusColor(controller.addressDetailsInfo?.statusText ?? "")),
          AddressDetailsInfoRow(label: "${'progress'.tr}:", value: controller.addressDetailsInfo?.progress ?? ""),
          AddressDetailsInfoRow(label: "${'materials'.tr}:", value: "${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.materials ?? ""}"),
          AddressDetailsInfoRow(label: "${'price_work'.tr}:", value: "${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.priceWork ?? ""}"),
          AddressDetailsInfoRow(label: "${'day_work'.tr}:", value: controller.addressDetailsInfo?.dayWork ?? ""),
          AddressDetailsInfoRow(label: "${'total'.tr}:", value: "${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.total ?? ""}"),
        ],
      ),
    );
  }
}