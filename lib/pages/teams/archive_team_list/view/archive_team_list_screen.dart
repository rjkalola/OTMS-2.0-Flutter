import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/teams/archive_team_list/controller/archive_team_list_controller.dart';
import 'package:otm_inventory/pages/teams/archive_team_list/view/widgets/search_team.dart';
import 'package:otm_inventory/pages/teams/archive_team_list/view/widgets/teams_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class ArchiveTeamListScreen extends StatefulWidget {
  const ArchiveTeamListScreen({super.key});

  @override
  State<ArchiveTeamListScreen> createState() => _ArchiveTeamListScreenState();
}

class _ArchiveTeamListScreenState extends State<ArchiveTeamListScreen> {
  final controller = Get.put(ArchiveTeamListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'archived_teams'.tr,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
              },
              bgColor: dashBoardBgColor,
            ),
            body: Obx(() {
              return ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            controller.getArchiveTeamListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Divider(),
                              SearchTeamWidget(),
                              TeamsList()
                            ],
                          ),
                        ));
            }),
          ),
        ),
      ),
    );
  }
}
