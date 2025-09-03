import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/pages/teams/create_team/view/widgets/add_team_member.dart';
import 'package:belcka/pages/teams/create_team/view/widgets/supervisor_textfield.dart';
import 'package:belcka/pages/teams/create_team/view/widgets/team_members_list.dart';
import 'package:belcka/pages/teams/create_team/view/widgets/team_name_textfield.dart';
import 'package:belcka/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:belcka/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:belcka/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/utils/app_utils.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final controller = Get.put(CreateTeamController());

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
                            Divider(),
                            Expanded(
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    TeamNameTextField(),
                                    SupervisorTextField(),
                                    AddTeamMember(),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    TeamMembersList()
                                  ],
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
                                    if (controller.teamInfo != null) {
                                      controller.updateTeamApi();
                                    } else {
                                      controller.createTeamApi();
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
}
