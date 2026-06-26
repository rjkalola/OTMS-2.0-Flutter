import 'package:belcka/pages/check_in/user_work_log_request/controller/user_work_log_request_controller.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/add_note_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/buttons/approve_reject_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkLogRequestFooter extends StatelessWidget {
  WorkLogRequestFooter({super.key});

  final controller = Get.put(UserWorkLogRequestController());

  static const Color _doneColor = Color(0xFF32A852);

  BoxDecoration _footerDecoration(BuildContext context) => BoxDecoration(
        color: backgroundColor_(context),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      );

  List<BoxShadow> _glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.62),
          blurRadius: 10,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showAdminFooter = controller.showAdminFooter;

      return Container(
        decoration: _footerDecoration(context),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: showAdminFooter
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AddNoteWidget(
                        controller: controller.noteController,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      ApproveRejectButtons(
                        padding: EdgeInsets.zero,
                        onClickApprove: controller.onApproveTap,
                        onClickReject: controller.onRejectTap,
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _glowShadow(_doneColor),
                      ),
                      child: ElevatedButton(
                        onPressed: controller.onBackPress,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _doneColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'done'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
