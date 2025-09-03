import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/project/archive_projects/controller/archive_project_list_controller.dart';
import 'package:belcka/pages/project/archive_projects/view/widgets/project_list.dart';
import 'package:belcka/pages/project/archive_projects/view/widgets/search_project.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class ArchiveProjectListScreen extends StatefulWidget {
  const ArchiveProjectListScreen({super.key});

  @override
  State<ArchiveProjectListScreen> createState() => _ArchiveProjectListScreenState();
}

class _ArchiveProjectListScreenState extends State<ArchiveProjectListScreen> {
  final controller = Get.put(ArchiveProjectListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor_(context),
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
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
              title: 'archived_projects'.tr,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
              },
              bgColor: dashBoardBgColor_(context),
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
                      controller.getArchiveProjectListApi();
                    },
                  )
                      : Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Column(
                      children: [
                        Divider(),
                        SearchProjectWidget(),
                        ProjectList()
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
