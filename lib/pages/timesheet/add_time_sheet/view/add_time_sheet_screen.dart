import 'package:belcka/pages/timesheet/add_time_sheet/controler/add_time_sheet_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddTimeSheetScreen extends StatefulWidget {
  const AddTimeSheetScreen({super.key});

  @override
  State<AddTimeSheetScreen> createState() => _AddTimeSheetScreenState();
}

class _AddTimeSheetScreenState extends State<AddTimeSheetScreen> {
  final controller = Get.put(AddTimeSheetController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'add_timesheet'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
                onBackPressed: controller.onBackPress,
              ),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Form(
                                  key: controller.formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible:
                                              controller.isAllUserTimeSheet,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12, bottom: 8),
                                            child: DropDownTextField(
                                              title: 'select_user'.tr,
                                              controller:
                                                  controller.userController,
                                              isArrowHide: false,
                                              validators: [
                                                // RequiredValidator(
                                                //     errorText:
                                                //         'required_field'.tr),
                                              ],
                                              onPressed: () {
                                                controller
                                                    .showSelectUserDialog();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        DropDownTextField(
                                          title: 'select_date'.tr,
                                          controller:
                                              controller.selectDateController,
                                          isArrowHide: false,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                          onPressed: () {
                                            controller.showDatePickerDialog(
                                              AppConstants
                                                  .dialogIdentifier.selectDate,
                                              controller.selectDate,
                                              DateTime(1900),
                                              DateTime.now(),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: DropDownTextField(
                                                title: 'start_shift'.tr,
                                                controller: controller
                                                    .startTimeController,
                                                isArrowHide: false,
                                                validators: [
                                                  RequiredValidator(
                                                      errorText:
                                                          'required_field'.tr),
                                                ],
                                                onPressed: () {
                                                  controller
                                                      .showTimePickerDialog(
                                                    AppConstants
                                                        .dialogIdentifier
                                                        .selectShiftStartTime,
                                                    controller.startShiftTime,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: DropDownTextField(
                                                title: 'end_shift'.tr,
                                                controller: controller
                                                    .endTimeController,
                                                isArrowHide: false,
                                                validators: [
                                                  RequiredValidator(
                                                      errorText:
                                                          'required_field'.tr),
                                                ],
                                                onPressed: () {
                                                  controller
                                                      .showTimePickerDialog(
                                                    AppConstants
                                                        .dialogIdentifier
                                                        .selectShiftEndTime,
                                                    controller.endShiftTime,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        DropDownTextField(
                                          title: 'select_project'.tr,
                                          controller:
                                              controller.projectController,
                                          isArrowHide: false,
                                          onPressed: () {
                                            controller
                                                .showSelectProjectDialog();
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        DropDownTextField(
                                          title: 'select_shift'.tr,
                                          controller:
                                              controller.shiftController,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                          isArrowHide: false,
                                          onPressed: () {
                                            controller.showSelectShiftDialog();
                                          },
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 18, 14, 16),
                              buttonText: 'save'.tr,
                              color: defaultAccentColor_(context),
                              onPressed: controller.onClickSave,
                            ),
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
