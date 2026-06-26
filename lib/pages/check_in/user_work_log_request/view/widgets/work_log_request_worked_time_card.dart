import 'package:belcka/pages/check_in/user_work_log_request/controller/user_work_log_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkLogRequestWorkedTimeCard extends StatelessWidget {
  WorkLogRequestWorkedTimeCard({super.key});

  final controller = Get.put(UserWorkLogRequestController());

  static const Color _cardBlue = Color(0xFFE8F3FC);
  static const Color _timeNavy = Color(0xFF1A2B4A);

  Color _hoursColor(BuildContext context, int status) {
    if (status == AppConstants.status.approved) {
      return approvedTextColor_(context);
    }
    if (status == AppConstants.status.rejected) {
      return rejectTextColor_(context);
    }
    if (status == AppConstants.status.pending) {
      return pendingTextColor_(context);
    }
    return _timeNavy;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.requestStatus;
      final isPending = status == AppConstants.status.pending;
      final oldSeconds =
          controller.workLogInfo.value.oldPayableWorkSeconds ?? 0;
      final newSeconds = controller.workLogInfo.value.payableWorkSeconds ?? 0;
      final hoursColor = _hoursColor(context, status);

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
        decoration: BoxDecoration(
          color: _cardBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.hoursTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor_(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isPending)
                    Row(
                      children: [
                        Text(
                          DateUtil.seconds_To_HH_MM(oldSeconds),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: _timeNavy,
                            height: 1.1,
                          ),
                        ),
                        const RightArrowWidget(size: 30),
                        Text(
                          DateUtil.seconds_To_HH_MM(newSeconds),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: hoursColor,
                            height: 1.1,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      controller.formattedWorkedTime,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: hoursColor,
                        height: 1.1,
                      ),
                    ),
                ],
              ),
            ),
            Image.asset(
              Drawable.stopShiftBlueClockIcon,
              width: 88,
              height: 88,
              fit: BoxFit.contain,
            ),
          ],
        ),
      );
    });
  }
}
