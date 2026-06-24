import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/pages/check_in/user_stop_shift/view/widgets/shift_completed_header.dart';
import 'package:belcka/pages/check_in/user_stop_shift/view/widgets/shift_done_footer.dart';
import 'package:belcka/pages/check_in/user_stop_shift/view/widgets/shift_earnings_card.dart';
import 'package:belcka/pages/check_in/user_stop_shift/view/widgets/shift_times_card.dart';
import 'package:belcka/pages/check_in/user_stop_shift/view/widgets/shift_todays_activity_card.dart';
import 'package:belcka/pages/check_in/user_stop_shift/view/widgets/shift_worked_time_card.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserStopShiftScreen extends StatefulWidget {
  const UserStopShiftScreen({super.key});

  @override
  State<UserStopShiftScreen> createState() => _UserStopShiftScreenState();
}

class _UserStopShiftScreenState extends State<UserStopShiftScreen> {
  final controller = Get.put(UserStopShiftController());

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
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: controller.isMainViewVisible.value,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CustomScrollView(
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
                                    ShiftCompletedHeader(),
                                    ShiftTimesCard(),
                                    ShiftWorkedTimeCard(),
                                    ShiftEarningsCard(),
                                    ShiftTodaysActivityCard(),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ShiftDoneFooter(),
                ],
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
