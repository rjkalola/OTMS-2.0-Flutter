import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:otm_inventory/pages/project/address_details/controller/address_details_controller.dart';
import 'package:otm_inventory/pages/project/address_details/view/widgets/address_details_info_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

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
          AddressDetailsInfoRow(label: "Project:", value: controller.addressDetailsInfo?.projectName ?? ""),
          AddressDetailsInfoRow(label: "Start date:", value: controller.addressDetailsInfo?.startDate ?? ""),
          AddressDetailsInfoRow(label: "End date:", value: controller.addressDetailsInfo?.endDate ?? ""),
          AddressDetailsInfoRow(label: "Status:", value: controller.addressDetailsInfo?.statusText ?? "", valueColor: getStatusColor(controller.addressDetailsInfo?.statusText ?? "")),
          AddressDetailsInfoRow(label: "Materials:", value: "${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.materials ?? ""}"),
          AddressDetailsInfoRow(label: "Price Work:", value: "${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.priceWork ?? ""}"),
          AddressDetailsInfoRow(label: "Day Work:", value:
          "${controller.addressDetailsInfo?.checkLog ?? ""} Hours (${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.dayWork ?? ""})"),
          AddressDetailsInfoRow(label: "Total:", value: "${controller.addressDetailsInfo?.currency ?? ""}${controller.addressDetailsInfo?.total ?? ""}"),
        ],
      ),
    );
  }
}