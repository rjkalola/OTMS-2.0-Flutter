import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadResultBottomSheet extends StatelessWidget {
  const DownloadResultBottomSheet({
    super.key,
    required this.onViewFile,
    required this.onClose,
    this.subtitle
  });

  final VoidCallback onViewFile;
  final VoidCallback onClose;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.7),
          child: Container(
            decoration: BoxDecoration(
              color: dashBoardBgColor_(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: titleBgColor_(context),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TitleTextView(
                          text: 'file_downloaded'.tr,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  child: TitleTextView(
                    text: 'view_downloaded_file'.tr,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: PrimaryButton(
                    buttonText: 'view_file'.tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    onPressed: onViewFile,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
