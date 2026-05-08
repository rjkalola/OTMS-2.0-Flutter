import 'package:belcka/pages/check_in/clock_in_offline/controller/clock_in_offline_controller.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in_offline/view/widgets/time_counter_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
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
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    // Always use a fresh, screen-scoped controller instance to avoid
    // route-removal races with previously registered global instances.
    _controllerTag = UniqueKey().toString();
    controller = Get.put(ClockInOfflineController(), tag: _controllerTag);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.onScreenEnter();
    });
  }

  @override
  void dispose() {
    if (Get.isRegistered<ClockInOfflineController>(tag: _controllerTag)) {
      Get.delete<ClockInOfflineController>(tag: _controllerTag, force: true);
    }
    super.dispose();
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
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    TimeCounterView(
                                      time: controller.totalWorkHours.value,
                                    ),
                                    const SizedBox(height: 16),
                                    _OfflineWorklogList(
                                        controller: controller),
                                  ],
                                ),
                              ),
                            ),
                            _OfflineWorkFooter(controller: controller),
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

class _OfflineWorklogList extends StatelessWidget {
  const _OfflineWorklogList({required this.controller});

  final ClockInOfflineController controller;

  String _displayTime(String? fullDateTime) {
    if (StringHelper.isEmptyString(fullDateTime)) return "-";
    try {
      return DateUtil.changeDateFormat(fullDateTime!,
          DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24);
    } catch (_) {
      return fullDateTime ?? "-";
    }
  }

  bool _isOngoing(WorkLogInfo log) {
    return !StringHelper.isEmptyString(log.workStartTime) &&
        StringHelper.isEmptyString(log.workEndTime);
  }

  String _payableText(WorkLogInfo log) {
    if (_isOngoing(log)) {
      try {
        final DateTime? start = DateUtil.stringToDate(
            log.workStartTime ?? "", DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
        if (start != null) {
          final int secs =
              DateUtil.dateDifferenceInSeconds(date1: start, date2: DateTime.now());
          return DateUtil.seconds_To_HH_MM_SS(secs < 0 ? 0 : secs);
        }
      } catch (_) {}
      return DateUtil.seconds_To_HH_MM_SS(0);
    }
    return DateUtil.seconds_To_HH_MM_SS(log.payableWorkSeconds ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = controller.totalWorkHours.value;
      final List<WorkLogInfo> logs = (controller.workLogData.workLogInfo ?? [])
          .where((e) => !StringHelper.isEmptyString(e.workStartTime))
          .toList()
        ..sort((a, b) =>
            (b.workStartTime ?? "").compareTo(a.workStartTime ?? ""));

      if (logs.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: dividerColor_(context)),
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor_(context),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('start_shift'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                Expanded(
                    child: Text('stop_shift'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                Expanded(
                    child: Text('payable'.tr,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            ...logs.map((log) {
              final ongoing = _isOngoing(log);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(_displayTime(log.workStartTime))),
                    Expanded(
                      child: Text(
                        ongoing ? 'ongoing'.tr : _displayTime(log.workEndTime),
                        style: TextStyle(
                          color: ongoing ? const Color(0xff007AFF) : null,
                          fontWeight:
                              ongoing ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _payableText(log),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}

class _OfflineWorkFooter extends StatelessWidget {
  const _OfflineWorkFooter({required this.controller});

  final ClockInOfflineController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        key: ValueKey(
            '${controller.totalWorkHours.value}_${controller.isLoading.value}_${controller.showStopButton}_${controller.showStartButton}'),
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
            child: controller.showStopButton
                ? PrimaryButton(
                    buttonText: 'stop_shift'.tr,
                    onPressed: () => controller.onStopWork(),
                    color: const Color(0xffFF6464),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )
                : controller.showStartButton
                    ? PrimaryButton(
                        buttonText: 'start_shift'.tr,
                        onPressed: () => controller.onStartWork(),
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
