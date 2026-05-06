import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/upload_offline_worklog/controller/upload_offline_worklog_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';

class UploadOfflineWorklogScreen extends StatefulWidget {
  const UploadOfflineWorklogScreen({super.key});

  @override
  State<UploadOfflineWorklogScreen> createState() =>
      _UploadOfflineWorklogScreenState();
}

class _UploadOfflineWorklogScreenState
    extends State<UploadOfflineWorklogScreen> {
  final controller = Get.put(UploadOfflineWorklogController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
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
                title: 'Upload Work Log',
                isCenterTitle: false,
                isBack: true,
                onBackPressed: () {
                  controller.onBackPress();
                },
                bgColor: dashBoardBgColor_(context),
              ),
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                            child: Column(
                              children: [
                                DropDownTextField(
                                  title: 'Select Project',
                                  controller: controller.projectController,
                                  borderRadius: 15,
                                  onPressed: controller.showSelectProjectDialog,
                                ),
                                const SizedBox(height: 18),
                                DropDownTextField(
                                  title: 'Select Shift',
                                  controller: controller.shiftController,
                                  borderRadius: 15,
                                  onPressed: controller.showSelectShiftDialog,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: PrimaryButton(
                            buttonText: 'Upload',
                            onPressed: () {
                              ClockInUtils.getOfflineRecordsUploadJson();
                              ClockInUtils.clearOfflineRecordsJson();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
