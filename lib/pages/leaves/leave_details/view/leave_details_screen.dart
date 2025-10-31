import 'package:belcka/pages/leaves/leave_details/view/widgets/all_day_off_view.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/all_day_on_view.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/all_day_widget.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/leave_note.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/total_time_requested.dart';
import 'package:belcka/pages/leaves/leave_details/controller/leave_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LeaveDetailsScreen extends StatefulWidget {
  const LeaveDetailsScreen({super.key});

  @override
  State<LeaveDetailsScreen> createState() => _LeaveDetailsScreenState();
}

class _LeaveDetailsScreenState extends State<LeaveDetailsScreen> {
  final controller = Get.put(LeaveDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.title.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
              widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          // controller.isInternetNotAvailable.value = false;
                          // controller.getTeamListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                              child: Form(
                                key: controller.formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 14),
                                        child: DropDownTextField(
                                          title: 'leave_type'.tr,
                                          controller:
                                              controller.leaveTypeController,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      divider(),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AllDayWidget(),
                                      AllDayOnView(),
                                      AllDayOffView(),
                                      divider(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TotalTimeRequested(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      divider(),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      LeaveNote(
                                        controller: controller.noteController,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value =
                                              !StringHelper.isEmptyString(
                                                  value);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                                padding: EdgeInsets.fromLTRB(14, 18, 14, 16),
                                buttonText: 'save'.tr,
                                color: controller.isSaveEnable.value
                                    ? defaultAccentColor_(context)
                                    : defaultAccentLightColor_(context),
                                onPressed: () {
                                  if (controller.isSaveEnable.value) {
                                    if (controller.valid()) {

                                    }
                                  }
                                })
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  Widget divider() => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Divider(
          height: 0,
        ),
      );

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.leaveInfo != null,
        child: TextButton(
            onPressed: () {
              controller.showRemoveLeaveDialog();
            },
            child: TitleTextView(
              text: 'delete'.tr,
              color: Colors.red,
            )),
      ),
    ];
  }
}
