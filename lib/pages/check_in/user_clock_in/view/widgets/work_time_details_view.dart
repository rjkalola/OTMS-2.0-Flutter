import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_controller.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/semi_circle_painter.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkTimeDetailsView extends StatelessWidget {
  WorkTimeDetailsView({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserClockInController>();
    final topPad = MediaQuery.of(context).padding.top;
    final headerH = MediaQuery.of(context).size.height * 0.268;

    return Obx(() {
        final statusText = _statusText(controller);
        final counterTime = _counterTime(controller);

        return Container(
          height: headerH,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientColors(controller),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: UserClockInSemiCirclePainter(),
                ),
              ),
              Positioned(
                top: topPad + 10,
                left: 16,
                child: GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: Color(0xFF555770),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 23,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (statusText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          statusText,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    if (statusText.isNotEmpty) const SizedBox(height: 4),
                    Text(
                      counterTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
  }

  List<Color> _gradientColors(UserClockInController controller) {
    if (controller.isOnLeave.value) {
      return const [Color(0xFF6B7280), Color(0xFF9CA3AF)];
    } else if (controller.isOnBreak.value) {
      return const [Color(0xFF9A4A00), Color(0xFFCE6700)];
    }
    return const [Color(0xFF1E376D), Color(0xFF3B6AD3)];
  }

  String _statusText(UserClockInController controller) {
    final isWorking = controller.workLogData.value.userIsWorking ?? false;
    if (!isWorking) {
      return '';
    }
    if (controller.isOnLeave.value) {
      return '';
    }
    if (controller.isOnBreak.value) {
      return 'break_time_on'.tr;
    }
    final projectName = controller.selectedWorkLogInfo?.projectName ??
        controller.workLogData.value.projectName;
    return StringHelper.isEmptyString(projectName) ? '' : projectName!;
  }

  String _counterTime(UserClockInController controller) {
    if (controller.isOnLeave.value) {
      return 'on_leave'.tr;
    } else if (controller.isOnBreak.value) {
      return controller.remainingBreakTime.value;
    }
    return controller.totalWorkHours.value;
  }
}
