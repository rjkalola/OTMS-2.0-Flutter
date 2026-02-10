import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_filter_item.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDocumentTabs extends StatelessWidget {
  PaymentDocumentTabs({super.key});

  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AddressDetailsFilterItem(
                title: 'invoices'.tr,
                action: AppConstants.action.invoices,
                selectedAction: controller.selectedFilter,
                count: controller.invoicesCount.value,
                onItemClick: (String action) {
                  controller.onTabChange(action);
                },
              ),
              SizedBox(
                width: 6,
              ),
              AddressDetailsFilterItem(
                title: 'payments'.tr,
                action: AppConstants.action.payments,
                selectedAction: controller.selectedFilter,
                count: controller.paymentsCount.value,
                onItemClick: (String action) {
                  controller.onTabChange(action);
                },
              ),
              SizedBox(
                width: 6,
              ),
              AddressDetailsFilterItem(
                title: 'payslips'.tr,
                action: AppConstants.action.payslips,
                selectedAction: controller.selectedFilter,
                count: controller.payslipsCount.value,
                onItemClick: (String action) {
                  controller.onTabChange(action);
                },
              ),
            ],
          ),
        ));
  }



}

// class _AddressFilterListState extends State<AddressFilterList> {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Padding(
//       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           AddressFilterItem(
//             title: 'all'.tr,
//             action: "all",
//             count: controller.allCount.value,
//           ),
//           SizedBox(
//             width: 6,
//           ),
//           AddressFilterItem(title: 'new'.tr, action: "new"),
//           SizedBox(
//             width: 6,
//           ),
//           AddressFilterItem(title: 'pending'.tr, action: "pending"),
//           SizedBox(
//             width: 6,
//           ),
//           AddressFilterItem(title: 'complete'.tr, action: "complete")
//         ],
//       ),
//     ),);
//   }
// }
