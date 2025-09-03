import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/project/project_info/controller/project_info_controller.dart';
import 'package:belcka/pages/project/project_info/view/widgets/grid_items.dart';
import 'package:belcka/pages/project/project_info/view/widgets/info_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/toolbar_menu_item_text_view.dart';

class ProjectInfoScreen extends StatefulWidget {
  const ProjectInfoScreen({super.key});

  @override
  State<ProjectInfoScreen> createState() => ProjectInfoScreenState();
}

class ProjectInfoScreenState extends State<ProjectInfoScreen>
    implements DateFilterListener {
  final controller = Get.put(ProjectInfoController());

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
              title: "",
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
                          controller.loadData(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InfoView(),
                              SizedBox(
                                height: 18,
                              ),
                              DateFilterOptionsHorizontalList(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                                startDate: controller.startDate,
                                endDate: controller.endDate,
                                listener: this,
                                selectedPosition:
                                    controller.selectedDateFilterIndex,
                              ),
                              GridItems()
                            ],
                          ),
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.isResetEnable.value,
        child: ToolbarMenuItemTextView(
          text: 'reset'.tr,
          padding: EdgeInsets.only(left: 6, right: 10),
          onTap: () {
            controller.clearFilter();
          },
        ),
      ),
      IconButton(
        icon: Icon(Icons.more_vert_outlined),
        onPressed: () {
          // controller.showMenuItemsDialog(Get.context!);
        },
      ),
    ];
  }

  @override
  void onSelectDateFilter(
      String startDate, String endDate, String dialogIdentifier) {
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.loadData(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
