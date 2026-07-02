import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckOutCopyHeaderBar extends StatelessWidget {
  const UserCheckOutCopyHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          UserCheckOutCopyBackButton(onPressed: () => Get.back()),
          const Spacer(),
        ],
      ),
    );
  }
}

class UserCheckOutCopyHeaderContent extends StatelessWidget {
  const UserCheckOutCopyHeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'check_out_'.tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor_(context),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'lets_wrap_up_work_day'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor_(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              Drawable.checkinMapImage,
              width: 160,
              height: 90,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class UserCheckOutCopyBackButton extends StatelessWidget {
  const UserCheckOutCopyBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          margin: const EdgeInsets.all(4),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: primaryTextColor_(context),
          ),
        ),
      ),
    );
  }
}
