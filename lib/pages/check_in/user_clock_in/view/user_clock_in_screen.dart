import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_controller.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/footer_button_check_in_switch_project.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/my_day_log_list_view.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/my_day_logs_title.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/work_time_details_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserClockInScreen extends StatefulWidget {
  const UserClockInScreen({super.key});

  @override
  State<UserClockInScreen> createState() => _UserClockInScreenState();
}

class _UserClockInScreenState extends State<UserClockInScreen> {
  late final UserClockInController controller;

  void _applyHeaderStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  void _restoreStatusBar() {
    AppUtils.setStatusBarColor(
        bottomNavigationBarColor: backgroundColor_(context));
  }

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<UserClockInController>()
        ? Get.find<UserClockInController>()
        : Get.put(UserClockInController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _applyHeaderStatusBar();
        controller.onScreenOpened();
      }
    });
  }

  @override
  void activate() {
    super.activate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _applyHeaderStatusBar();
    });
  }

  @override
  void deactivate() {
    _restoreStatusBar();
    super.deactivate();
  }

  @override
  void dispose() {
    _restoreStatusBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _applyHeaderStatusBar();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? const NoInternetWidget()
                : Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Column(
                      children: [
                        WorkTimeDetailsView(
                          onBackPressed: controller.onBackPress,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              // MyDayLogsTitle(),
                              MyDayLogListView(),
                              FooterButtonCheckInSwitchProject(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }),
      ),
    );
  }
}
