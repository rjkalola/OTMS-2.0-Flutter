import 'package:belcka/pages/notifications/announcement_details/controller/announcement_details_controller.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/view/widgets/attachment_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  const AnnouncementDetailsScreen({super.key});

  @override
  State<AnnouncementDetailsScreen> createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  final controller = Get.put(AnnouncementDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => PopScope(
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
                title: "",
                isCenterTitle: false,
                isBack: false,
                onBackPressed: () {
                  controller.onBackPress();
                },
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
                            controller.isInternetNotAvailable.value = false;
                            controller.announcementDetailApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: UserAvtarView(
                                          imageUrl: controller.info.value
                                                  .senderThumbImage ??
                                              "",
                                          imageSize: 52,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12),
                                              child: PrimaryTextView(
                                                text:
                                                    "Announcement from ${controller.info.value.senderName ?? ""}: ${controller.info.value.name ?? ""}",
                                                fontSize: 17,
                                                color:
                                                    primaryTextColor_(context),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12, top: 4),
                                              child: PrimaryTextView(
                                                text: controller
                                                        .info.value.date ??
                                                    "",
                                                fontSize: 14,
                                                color: secondaryLightTextColor_(
                                                    context),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Divider(
                                  height: 0,
                                  color: dividerColor_(context),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: TitleTextView(
                                    text: "${'send_notification_as'.tr}:",
                                    fontWeight: FontWeight.w400,
                                    color: secondaryTextColor_(context),
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 3),
                                  child: TitleTextView(
                                    text: controller.info.value.type ?? "",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Divider(
                                  height: 0,
                                  color: dividerColor_(context),
                                ),
                                !StringHelper.isEmptyList(
                                        controller.info.value.documents)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: TitleTextView(
                                              text: 'attachment'.tr,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 3, 8, 14),
                                            child: AttachmentList(
                                              onGridItemClick:
                                                  controller.onGridItemClick,
                                              filesList: controller
                                                  .info.value.documents!.obs,
                                              parentIndex: 0,
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                            color: dividerColor_(context),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: UserUtils.isAdmin(),
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }
}
