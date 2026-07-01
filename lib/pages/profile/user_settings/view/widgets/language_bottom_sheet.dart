import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/language_utils.dart';
import 'package:belcka/widgets/image/circular_svg_assets_image.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({
    super.key,
    required this.selectedKey,
    required this.onSelected,
  });

  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: dividerColor_(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          PrimaryTextView(
            text: 'language'.tr,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...LanguageUtils.languages.map((language) {
            final isSelected = language.localeKey == selectedKey;
            return InkWell(
              onTap: () {
                onSelected(language.localeKey);
                Get.back();
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    CircularSvgAssetsImage(
                      assetsPath: language.flagAsset,
                      width: 28,
                      height: 28,
                      radiusSize: 14,
                      placeHolderSize: 28,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryTextView(
                        text: language.titleKey.tr,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        color: defaultAccentColor_(context),
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
