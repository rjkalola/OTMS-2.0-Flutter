import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateListItem extends StatelessWidget {
  const CertificateListItem({
    super.key,
    required this.info,
    required this.iconBackgroundColor,
    this.onTap,
  });

  final CertificateInfo info;
  final String iconBackgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(context, info.status ?? "");
    final hasStatus = !StringHelper.isEmptyString(info.status);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CardViewDashboardItem(
          borderRadius: 14,
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          padding: EdgeInsets.fromLTRB(
            12,
            hasStatus ? 10 : 14,
            12,
            14,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CertificateIconBox(colorHex: iconBackgroundColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: hasStatus ? 72 : 0),
                        child: PrimaryTextView(
                          text: info.documentType ?? "",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!StringHelper.isEmptyString(info.cardNumber)) ...[
                        const SizedBox(height: 4),
                        PrimaryTextView(
                          text: '${'certificate_no'.tr} ${info.cardNumber}',
                          fontSize: 13,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                      ],
                      if (!StringHelper.isEmptyString(info.expiryDate)) ...[
                        const SizedBox(height: 2),
                        PrimaryTextView(
                          text: '${'valid_until'.tr} ${info.expiryDate}',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                RightArrowWidget(color: secondaryExtraLightTextColor_(context)),
              ],
            ),
          ),
        ),
        if (hasStatus)
          Positioned(
            top: 0,
            right: 36,
            child: TextViewWithContainer(
              text: info.status ?? "",
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontColor: statusStyle.textColor,
              boxColor: statusStyle.backgroundColor,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            ),
          ),
      ],
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

class _CertificateIconBox extends StatelessWidget {
  const _CertificateIconBox({required this.colorHex});

  final String colorHex;

  @override
  Widget build(BuildContext context) {
    final iconColor = Color(AppUtils.haxColor(colorHex));

    return Container(
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
