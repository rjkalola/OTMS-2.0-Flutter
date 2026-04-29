import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Circular upload control beside team/user dropdowns (create announcement).
class AnnouncementUploadButton extends StatelessWidget {
  const AnnouncementUploadButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 86,
          height: 86,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : const Color(0xffE8E8E8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_outlined,
                size: 26,
                color: primaryTextColor_(context),
              ),
              const SizedBox(height: 4),
              PrimaryTextView(
                text: 'upload_announcement_short'.tr,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                maxLine: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
