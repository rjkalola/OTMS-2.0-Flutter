import 'package:belcka/pages/check_in/clock_in_offline/controller/clock_in_offline_controller.dart';
import 'package:belcka/pages/check_in/clock_in_offline/view/widgets/time_counter_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ClockInOfflineScreen extends StatefulWidget {
  const ClockInOfflineScreen({super.key});

  @override
  State<ClockInOfflineScreen> createState() => _ClockInOfflineScreenState();
}

class _ClockInOfflineScreenState extends State<ClockInOfflineScreen> {
  late final ClockInOfflineController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ClockInOfflineController());
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor(
        bottomNavigationBarColor: backgroundColor_(context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'work_log'.tr,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
              },
              bgColor: dashBoardBgColor_(context),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Obx(() {
                  return SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: ModalProgressHUD(
                      inAsyncCall: controller.isLoading.value,
                      opacity: 0,
                      progressIndicator: const CustomProgressbar(),
                      child: Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: TimeCounterView(),
                                ),
                              ),
                            ),
                            const _OfflineWorkFooter(),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OfflineWorkFooter extends StatelessWidget {
  const _OfflineWorkFooter();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ClockInOfflineController>();
    return Obx(() {
      return Container(
        key: ValueKey(
            '${c.totalWorkHours.value}_${c.isLoading.value}_${c.showStopButton}_${c.showStartButton}'),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: c.showStopButton
                ? PrimaryButton(
                    buttonText: 'stop_shift'.tr,
                    onPressed: () => c.onStopWork(),
                    color: const Color(0xffFF6464),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )
                : c.showStartButton
                    ? PrimaryButton(
                        buttonText: 'start_shift'.tr,
                        onPressed: () => c.onStartWork(),
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )
                    : const SizedBox.shrink(),
          ),
        ),
      );
    });
  }
}
