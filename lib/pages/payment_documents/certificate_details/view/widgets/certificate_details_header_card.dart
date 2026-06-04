import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';
import 'package:belcka/pages/payment_documents/certificate_details/view/widgets/certificate_detail_row.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDetailsHeaderCard extends StatelessWidget {
  const CertificateDetailsHeaderCard({
    super.key,
    required this.info,
    required this.iconColorHex,
  });

  final CertificateInfo info;
  final String iconColorHex;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(context, info.status ?? "");
    final hasStatus = !StringHelper.isEmptyString(info.status);
    final iconColor = Color(AppUtils.haxColor(iconColorHex));

    return CardViewDashboardItem(
      borderRadius: 20,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.userCertificateAvtarImage,
                  color: iconColor,
                  width: 27,
                  height: 27,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextView(
                      text: info.documentType ?? "",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      maxLine: 3,
                    ),
                    if (hasStatus) ...[
                      const SizedBox(height: 4),
                      TextViewWithContainer(
                        text: info.status ?? "",
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontColor: statusStyle.textColor,
                        boxColor: statusStyle.backgroundColor,
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CertificateDetailRow(
            label: 'certificate_no'.tr,
            value: info.cardNumber,
          ),
          CertificateDetailRow(
            label: 'expiry_date'.tr,
            value: info.expiryDate,
          ),
          CertificateDetailRow(
            label: 'uploaded'.tr,
            value: info.uploadedDate,
          ),
        ],
      ),
    );
  }

  static _StatusStyle _statusStyle(BuildContext context, String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('expired')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFFE8E8),
        textColor: rejectTextColor_(context),
      );
    }
    if (normalized.contains('expiring')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFFF0E0),
        textColor: pendingTextColor_(context),
      );
    }
    return _StatusStyle(
      backgroundColor: const Color(0xFFE5F6EA),
      textColor: approvedTextColor_(context),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;
}
