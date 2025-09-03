import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/check_in/select_project/controller/select_project_controller.dart';
import 'package:belcka/pages/check_in/select_project/view/widgets/projects_list.dart';
import 'package:belcka/pages/check_in/select_project/view/widgets/search_project.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/map_view/bottom_curve_container.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/map_view/map_back_arrow.dart';
import 'package:belcka/widgets/other_widgets/selection_screen_header_view.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';

class SelectProjectScreen extends StatefulWidget {
  const SelectProjectScreen({super.key});

  @override
  State<SelectProjectScreen> createState() => _SelectProjectScreenState();
}

class _SelectProjectScreenState extends State<SelectProjectScreen> {
  final controller = Get.put(SelectProjectController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: controller.isMainViewVisible.value,
              child: Column(children: [
                Flexible(
                  flex: 2,
                  child: Stack(
                    children: [
                      CustomMapView(
                        onMapCreated: controller.onMapCreated,
                        target: controller.center,
                      ),
                      MapBackArrow(onBackPressed: () {
                        Get.back();
                      }),
                      BottomCurveContainer()
                    ],
                  ),
                ),
                Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        SelectionScreenHeaderView(
                          title: 'select_project'.tr,
                          onBackPressed: () {
                            Get.back();
                          },
                        ),
                        SearchProject(),
                        ProjectsList(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextViewWithContainer(
                                  onTap: () {
                                    controller.moveToScreen(0);
                                  },
                                  padding: EdgeInsetsDirectional.all(9),
                                  width: double.infinity,
                                  text: 'skip'.tr,
                                  borderColor: Colors.grey,
                                  alignment: Alignment.center,
                                  borderRadius: 45,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextViewWithContainer(
                                  onTap: () {
                                    Get.back();
                                  },
                                  padding: EdgeInsetsDirectional.all(9),
                                  width: double.infinity,
                                  text: 'cancel'.tr,
                                  borderColor: Colors.grey,
                                  alignment: Alignment.center,
                                  borderRadius: 45,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
              ]),
            ),
          ),
        ),
      )),
    );
  }
}
