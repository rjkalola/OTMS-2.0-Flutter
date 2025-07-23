import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/project/project_list/controller/project_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import '../../../../utils/app_constants.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'Projects (All)',
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
            widgets: actionButtons(),
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? const Center(
                    child: Text("No Internet"),
                  )
                : Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: // Project List
                        Expanded(
                      child: ListView.builder(
                        itemCount: controller.projectsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 3.0),
                            child: CardViewDashboardItem(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                              child: InkWell(
                                onTap: () {
                                  var arguments = {
                                    AppConstants.intentKey.projectInfo:
                                        controller.projectsList[index],
                                  };
                                  controller.moveToScreen(
                                      AppRoutes.addProjectScreen, arguments);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.projectsList[index].name ?? "",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: primaryTextColor_(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
          ),
          bottomNavigationBar: CommonBottomNavigationBarWidget(),
        ))));
  }

  List<Widget>? actionButtons() {
    return [
      CardViewDashboardItem(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Text(
          "Stats",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
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
