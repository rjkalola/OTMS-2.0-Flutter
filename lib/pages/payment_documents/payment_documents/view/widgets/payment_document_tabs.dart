import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDocumentTabs extends StatelessWidget {
  PaymentDocumentTabs({super.key, this.bottomPadding = 16});

  final double bottomPadding;
  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, bottomPadding),
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderFilterItem(
                  title: 'invoices'.tr,
                  selected: controller.selectedFilter.value ==
                      AppConstants.action.invoices,
                  count: controller.invoicesCount,
                  useFlexible: false,
                  onTap: () =>
                      controller.onTabChange(AppConstants.action.invoices),
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'payments'.tr,
                  selected: controller.selectedFilter.value ==
                      AppConstants.action.payments,
                  count: controller.paymentsCount,
                  useFlexible: false,
                  onTap: () =>
                      controller.onTabChange(AppConstants.action.payments),
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'payslips'.tr,
                  selected: controller.selectedFilter.value ==
                      AppConstants.action.payslips,
                  count: controller.payslipsCount,
                  useFlexible: false,
                  onTap: () =>
                      controller.onTabChange(AppConstants.action.payslips),
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'certificates'.tr,
                  selected: controller.selectedFilter.value ==
                      AppConstants.action.certificates,
                  useFlexible: false,
                  onTap: () =>
                      controller.onTabChange(AppConstants.action.certificates),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
