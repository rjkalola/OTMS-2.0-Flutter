import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/controller/team_users_count_info_controller.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/view/widgets/team_users_count_items_list.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/utils/app_utils.dart';

class TeamUsersCountInfoScreen extends StatefulWidget {
  TeamUsersCountInfoScreen({super.key});

  @override
  State<TeamUsersCountInfoScreen> createState() =>
      _TeamUsersCountInfoScreenState();
}

class _TeamUsersCountInfoScreenState extends State<TeamUsersCountInfoScreen> {
  final controller = Get.put(TeamUsersCountInfoController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getCompanyResourcesApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                const TopDividerWidget(
                                  flex1: 4,
                                  flex2: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 14, 16, 0),
                                  child: HeaderLogo(
                                    isBackDisable: true,
                                  ),
                                ),
                                HeaderTitleNoteTextWidget(
                                  title: 'how_many_users_Are_on_your_team'.tr,
                                ),
                                TeamUsersCountItemsList(
                                    itemsList: controller.listItems,
                                    onViewClick: (position) {
                                      print("position:" + position.toString());
                                      controller.selectedIndex.value = position;
                                    },
                                    selectedIndex:
                                        controller.selectedIndex.value),
                                Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 16, 20, 16),
                                    width: double.infinity,
                                    child: ContinueButton(onPressed: () {
                                      controller.onClickContinueButton();
                                    }))
                              ],
                            ),
                          ]),
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
