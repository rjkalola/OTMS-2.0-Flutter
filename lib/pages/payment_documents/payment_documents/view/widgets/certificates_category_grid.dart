import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificatesCategoryGrid extends StatelessWidget {
  CertificatesCategoryGrid({super.key});

  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final items = [
          _CategoryItem(
            action: AppConstants.action.certificateExpiredSoon,
            title: 'expired_soon'.tr,
            count: controller.certificatesExpiredSoonCount.value,
            countColor: rejectTextColor_(context),
            iconPath: Drawable.clockPermissionIcon,
            iconColor: primaryTextColor_(context),
          ),
          _CategoryItem(
            action: AppConstants.action.certificateInsurance,
            title: 'insurance'.tr,
            count: controller.certificatesInsuranceCount.value,
            countColor: secondaryExtraLightTextColor_(context),
            iconPath: Drawable.healthPermissionIcon,
            iconColor: defaultAccentColor_(context),
          ),
          _CategoryItem(
            action: AppConstants.action.certificateDocuments,
            title: 'certificates'.tr,
            count: controller.certificatesDocumentsCount.value,
            countColor: secondaryExtraLightTextColor_(context),
            iconPath: Drawable.healthPermissionIcon,
            iconColor: defaultAccentColor_(context),
          ),
          _CategoryItem(
            action: AppConstants.action.certificateDrivingLicense,
            title: 'driving_license'.tr,
            count: controller.certificatesDrivingLicenseCount.value,
            countColor: secondaryExtraLightTextColor_(context),
            iconPath: Drawable.healthPermissionIcon,
            iconColor: defaultAccentColor_(context),
          ),
        ];

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 102,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return InkWell(
                onTap: () =>
                    controller.onCertificateCategorySelected(item.action),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: CardViewDashboardItem(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _CategoryIcon(
                        iconPath: item.iconPath,
                        iconColor: item.iconColor,
                        showWarning: item.action ==
                            AppConstants.action.certificateExpiredSoon,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PrimaryTextView(
                              text: item.title,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              maxLine: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            PrimaryTextView(
                              text: item.count.toString(),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: item.countColor,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.iconPath,
    required this.iconColor,
    required this.showWarning,
  });

  final String iconPath;
  final Color iconColor;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ImageUtils.setSvgAssetsImage(
            path: iconPath,
            color: iconColor,
            width: 30,
            height: 30,
          ),
          if (showWarning)
            Positioned(
              left: -2,
              bottom: -2,
              child: Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: primaryTextColor_(context),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem({
    required this.action,
    required this.title,
    required this.count,
    required this.countColor,
    required this.iconPath,
    required this.iconColor,
  });

  final String action;
  final String title;
  final int count;
  final Color countColor;
  final String iconPath;
  final Color iconColor;
}
