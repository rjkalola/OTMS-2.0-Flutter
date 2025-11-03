import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
import 'package:belcka/pages/project/project_list/view/widgets/projects_list.dart';
import 'package:belcka/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:belcka/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:belcka/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class ProjectListScreen2 extends StatefulWidget {
  const ProjectListScreen2({super.key});

  @override
  State<ProjectListScreen2> createState() => _ProjectListScreen2State();
}

class _ProjectListScreen2State extends State<ProjectListScreen2> {
  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'project_all'.tr,
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
                          controller.isInternetNotAvailable.value = false;
                          controller.getProjectListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [ProjectsList()],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      // CardViewDashboardItem(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //   child: const Text(
      //     "Stats",
      //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      //   ),
      // ),
      const SizedBox(width: 10),
      Visibility(
        visible: true,
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
