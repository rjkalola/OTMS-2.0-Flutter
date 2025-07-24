import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/project/project_list/controller/project_list_controller.dart';
import 'package:otm_inventory/pages/project/project_list/view/widgets/projects_list.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
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
