import 'package:belcka/pages/check_in/user_work_log_request/controller/user_work_log_request_controller.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/pending_request_time_box.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/start_stop_box_row.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/requested_note_widget.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/total_hours_row.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/work_log_request_footer.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/work_log_request_header.dart';
import 'package:belcka/pages/check_in/user_work_log_request/view/widgets/work_log_request_worked_time_card.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserWorkLogRequestScreen extends StatefulWidget {
  const UserWorkLogRequestScreen({super.key});

  @override
  State<UserWorkLogRequestScreen> createState() =>
      _UserWorkLogRequestScreenState();
}

class _UserWorkLogRequestScreenState extends State<UserWorkLogRequestScreen> {
  final controller = Get.put(UserWorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Form(
                key: controller.formKey,
                child: Visibility(
                  visible: controller.isMainViewVisible.value,
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: SafeArea(
                                bottom: false,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 4),
                                        child: _BackButton(
                                          onPressed: controller.onBackPress,
                                        ),
                                      ),
                                    ),
                                    WorkLogRequestHeader(),
                                    if ((controller.workLogInfo.value.status ??
                                            0) ==
                                        AppConstants.status.pending)
                                      PendingRequestTimeBox()
                                    else
                                      StartStopBoxRow(),
                                    // TotalHoursRow(),
                                    WorkLogRequestWorkedTimeCard(),
                                    RequestedNoteWidget(),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WorkLogRequestFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 42,
          height: 42,
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
