import 'package:belcka/pages/payment_documents/certificate_details/controller/certificate_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDetailsActions extends StatelessWidget {
  CertificateDetailsActions({super.key});

  final controller = Get.put(CertificateDetailsController());

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);
    final deleteColor = rejectTextColor_(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextView(
            text: 'actions'.tr,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10),
          CardViewDashboardItem(
            borderRadius: 16,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ActionTile(
                  title: 'view_document'.tr,
                  color: accentColor,
                  icon: ImageUtils.setSvgAssetsImage(
                    path: Drawable.pdfIcon,
                    color: accentColor,
                    width: 22,
                    height: 22,
                  ),
                  onTap: controller.onViewDocument,
                  showDivider: true,
                ),
                _ActionTile(
                  title: 'replace_document'.tr,
                  color: accentColor,
                  icon: Icon(
                    Icons.autorenew_rounded,
                    color: accentColor,
                    size: 22,
                  ),
                  onTap: controller.onReplaceDocument,
                  showDivider: true,
                ),
                _ActionTile(
                  title: 'delete_document'.tr,
                  color: deleteColor,
                  icon: ImageUtils.setSvgAssetsImage(
                    path: Drawable.deleteIcon,
                    color: deleteColor,
                    width: 22,
                    height: 22,
                  ),
                  onTap: controller.onDeleteDocument,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
    required this.showDivider,
  });

  final String title;
  final Color color;
  final Widget icon;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: icon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryTextView(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor_(context),
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}
