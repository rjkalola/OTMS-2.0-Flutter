import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_announcement_controller.dart';

class SendNotificationAsWidget extends StatelessWidget {
  SendNotificationAsWidget({super.key});

  final controller = Get.put(CreateAnnouncementController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = isDark ? const Color(0xff3A3A3A) : const Color(0xffE5E5E5);

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 0, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextView(
              text: "${'send_notification_as'.tr}:",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 38,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: track,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    clipBehavior: Clip.antiAlias,
                  ),
                  SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Expanded(
                          child: _Segment(
                            label: 'company'.tr,
                            selected: controller.sendNotificationAs.value ==
                                "company",
                            onTap: () =>
                                controller.sendNotificationAs.value = "company",
                          ),
                        ),
                        Expanded(
                          child: _Segment(
                            label: 'admin'.tr,
                            selected:
                                controller.sendNotificationAs.value == "admin",
                            onTap: () =>
                                controller.sendNotificationAs.value = "admin",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedBg = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff232323)
        : Colors.white;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.34)
        : Colors.black.withValues(alpha: 0.14);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedShadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: PrimaryTextView(
            text: label,
            fontSize: 16,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
