import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftTodaysActivityCard extends StatefulWidget {
  const ShiftTodaysActivityCard({super.key});

  @override
  State<ShiftTodaysActivityCard> createState() =>
      _ShiftTodaysActivityCardState();
}

class _ShiftTodaysActivityCardState extends State<ShiftTodaysActivityCard> {
  final controller = Get.put(UserStopShiftController());
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final visibleLogs = controller.todaysActivityCheckLogs;

      if (visibleLogs.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'todays_activity'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor_(context),
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: dividerColor_(context),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: secondaryTextColor_(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: _expanded
                  ? Column(
                      children: [
                        Divider(height: 1, color: dividerColor_(context)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 12, 8),
                          child: Column(
                            children: visibleLogs
                                .map((log) => _ActivityItem(
                                      info: log,
                                      onTap: () =>
                                          controller.onCheckLogItemTap(log),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.info, required this.onTap});

  final CheckLogInfo info;
  final VoidCallback onTap;

  static const Color _iconGreen = Color(0xFF2E9E4F);
  static const Color _iconGreenBg = Color(0xFFD9F2DE);

  @override
  Widget build(BuildContext context) {
    final taskName = !StringHelper.isEmptyString(info.companyTaskName)
        ? info.companyTaskName
        : info.tradeName;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: _iconGreenBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: _iconGreen,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  if (!StringHelper.isEmptyString(info.addressName)) ...[
                    const SizedBox(height: 2),
                    Text(
                      info.addressName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor_(context),
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: secondaryTextColor_(context),
            ),
          ],
        ),
      ),
    );
  }
}
