import 'package:belcka/pages/project/project_list/view/widgets/address_list.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
import 'package:belcka/pages/project/project_list/view/widgets/project_list_header_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: "",
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                          children: [
                            ProjectListHeaderView(),
                            SizedBox(
                              height: 14,
                            ),
                            AddressList()
                          ],
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
