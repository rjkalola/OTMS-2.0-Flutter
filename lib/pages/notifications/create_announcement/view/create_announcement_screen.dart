import 'package:belcka/pages/notifications/create_announcement/controller/create_announcement_controller.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/all_company_users_checkbox.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/announcement_attachment_strip.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/announcement_upload_button.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/send_notification_as_widget.dart';
import 'package:belcka/pages/notifications/create_announcement/view/widgets/write_announcement.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.32)
        : Colors.black.withValues(alpha: 0.08);
    return Obx(
      () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'new_announcement_title'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          onPanDown: (_) => FocusScope.of(context).unfocus(),
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            children: [
                              Expanded(
                                child: Form(
                                  key: controller.formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // const SizedBox(height: 12),
                                        Container(
                                          margin: EdgeInsets.zero,
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 8, 4, 12),
                                          decoration: BoxDecoration(
                                            color: backgroundColor_(context),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(22),
                                                bottomRight:
                                                    Radius.circular(22)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: cardShadowColor,
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Obx(
                                                        () => Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AllCompanyUsersCheckbox(),
                                                            if (!controller
                                                                .isCompanyUsers
                                                                .value) ...[
                                                              const SizedBox(
                                                                  height: 16),
                                                              DropDownTextField(
                                                                title:
                                                                    'select_team'
                                                                        .tr,
                                                                controller:
                                                                    controller
                                                                        .teamsController,
                                                                isArrowHide:
                                                                    false,
                                                                isEnabled:
                                                                    !controller
                                                                        .isCompanyUsers
                                                                        .value,
                                                                borderRadius:
                                                                    24,
                                                                validators: [],
                                                                onPressed: () {
                                                                  controller
                                                                      .showTeamList();
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              DropDownTextField(
                                                                title:
                                                                    'select_users'
                                                                        .tr,
                                                                controller:
                                                                    controller
                                                                        .usersController,
                                                                isEnabled:
                                                                    !controller
                                                                        .isCompanyUsers
                                                                        .value,
                                                                isArrowHide:
                                                                    false,
                                                                borderRadius:
                                                                    24,
                                                                validators: [],
                                                                onPressed: () {
                                                                  controller
                                                                      .showUserList();
                                                                },
                                                              ),
                                                            ],
                                                            const SizedBox(
                                                                height: 16),
                                                            SendNotificationAsWidget(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    AnnouncementUploadButton(
                                                      onPressed: () {
                                                        controller.showAttachmentOptionsDialog();
                                                        // controller
                                                        //     .onGridItemClick(
                                                        //   0,
                                                        //   AppConstants
                                                        //       .action.viewPhoto,
                                                        // );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        AnnouncementAttachmentStrip(
                                          filesList: controller.attachmentList,
                                          onGridItemClick:
                                              controller.onGridItemClick,
                                        ),
                                        const SizedBox(height: 16),
                                        WriteAnnouncement(
                                          controller: controller
                                              .writeAnnouncementController,
                                          onValueChange: (value) {
                                            controller.isSaveEnable.value =
                                                !StringHelper.isEmptyString(
                                                    value);
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              PrimaryButton(
                                  margin:
                                      const EdgeInsets.fromLTRB(14, 18, 14, 16),
                                  buttonText: 'publish_announcement'.tr,
                                  color: controller.isSaveEnable.value
                                      ? defaultAccentColor_(context)
                                      : defaultAccentLightColor_(context),
                                  onPressed: () {
                                    if (StringHelper.isEmptyString(controller
                                        .writeAnnouncementController.value.text
                                        .trim())) {
                                      AppUtils.showToastMessage(
                                          'please_write_announcement'.tr);
                                      return;
                                    }
                                    controller.createAnnouncementApi();
                                  }),
                            ],
                          ),
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
