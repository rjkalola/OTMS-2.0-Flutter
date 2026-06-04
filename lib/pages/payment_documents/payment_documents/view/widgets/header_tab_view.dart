import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/payment_document_tabs.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderTabView extends StatelessWidget {
  HeaderTabView({super.key});

  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
          border: Border.all(width: 0.6, color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentDocumentTabs(
              bottomPadding: controller.selectedFilter.value ==
                      AppConstants.action.certificates
                  ? 8
                  : 16,
            ),
            if (controller.selectedFilter.value ==
                AppConstants.action.certificates)
              _CertificatesSummaryRow(
                validCount: controller.certificatesValidCount.value,
                expiringSoonCount:
                    controller.certificatesExpiringSoonCount.value,
              ),
          ],
        ),
      ),
    );
  }
}

class _CertificatesSummaryRow extends StatelessWidget {
  const _CertificatesSummaryRow({
    required this.validCount,
    required this.expiringSoonCount,
  });

  final int validCount;
  final int expiringSoonCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  count: validCount,
                  label: 'valid'.tr,
                  countColor: approvedTextColor_(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8),
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: dividerColor_(context),
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  count: expiringSoonCount,
                  label: 'expiring_soon'.tr,
                  countColor: pendingTextColor_(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.count,
    required this.label,
    required this.countColor,
  });

  final int count;
  final String label;
  final Color countColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryTextView(
            text: count.toString(),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: countColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          PrimaryTextView(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: secondaryExtraLightTextColor_(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
