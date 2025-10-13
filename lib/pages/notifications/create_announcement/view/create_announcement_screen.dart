import 'package:belcka/pages/notifications/create_announcement/controller/create_announcement_controller.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/all_company_users_checkbox.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/attachment_list.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/send_notification_as_widget.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/write_announcement.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final controller = Get.put(CreateAnnouncementController());

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
              title: 'announcement'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.loadResources(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            // Divider(),
                            Expanded(
                              child: Form(
                                key: controller.formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      WriteAnnouncement(
                                        controller: controller
                                            .writeAnnouncementController,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value =
                                              !StringHelper.isEmptyString(
                                                  value);
                                        },
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      AllCompanyUsersCheckbox(),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: DropDownTextField(
                                          title: 'select_teams'.tr,
                                          controller:
                                              controller.teamsController,
                                          isArrowHide: false,
                                          isEnabled:
                                              !controller.isCompanyUsers.value,
                                          validators: [],
                                          onPressed: () {
                                            controller.showTeamList();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: DropDownTextField(
                                          title: 'select_users'.tr,
                                          controller:
                                              controller.usersController,
                                          isEnabled:
                                              !controller.isCompanyUsers.value,
                                          isArrowHide: false,
                                          validators: [],
                                          onPressed: () {
                                            controller.showUserList();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                      SendNotificationAsWidget(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: PrimaryTextView(
                                          text: 'attachment'.tr,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      AttachmentList(
                                          onGridItemClick:
                                              controller.onGridItemClick,
                                          filesList: controller.attachmentList)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                                padding: EdgeInsets.fromLTRB(14, 18, 14, 16),
                                buttonText: 'submit'.tr,
                                color: controller.isSaveEnable.value
                                    ? defaultAccentColor_(context)
                                    : defaultAccentLightColor_(context),
                                onPressed: () {
                                  if (controller.isSaveEnable.value &&
                                      controller.valid()) {
                                    controller.createAnnouncementApi();
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
}
