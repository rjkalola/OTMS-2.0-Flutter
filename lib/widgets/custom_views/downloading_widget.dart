import 'dart:ui';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadLoader extends StatelessWidget {
  final int progress;
  final String? title;
  final VoidCallback? onCancel;

  const DownloadLoader({
    super.key,
    required this.progress,
    this.title,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark blur background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ),

        // Loader Card
        Center(
          child: Container(
            width: 220,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor_(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 4,
                ),
                // Circular progress
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          value: progress / 100,
                          backgroundColor: lightGreyColor(context),
                          color: defaultAccentColor_(context),
                        ),
                      ),
                      PrimaryTextView(
                        text: "$progress%",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                PrimaryTextView(
                  text: title ?? 'downloading'.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 2),

                PrimaryTextView(
                  text: 'please_wait'.tr,
                  fontSize: 13,
                  color: secondaryExtraLightTextColor_(context),
                ),

                if (onCancel != null) ...[
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: onCancel,
                    child: Text('cancel'.tr),
                  )
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}
