import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/profile/my_account/view/widgets/menu_buttons_grid_widget.dart';
import 'package:otm_inventory/pages/profile/my_account/view/widgets/my_account_bottom_navigation_bar.dart';
import 'package:otm_inventory/pages/project/project_details/controller/project_details_controller.dart';
import 'package:otm_inventory/pages/project/project_details/model/project_detals_item.dart';
import 'package:otm_inventory/pages/project/project_info/model/project_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final controller = Get.put(ProjectDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.projectInfo?.name ?? "",
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
                  ? Center(
                      child: Text('no_internet_text'.tr),
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Container(
                        padding: EdgeInsets.only(top: 16),
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 90,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (controller.items[index].title ==
                                    "Addresses") {
                                  var arguments = {
                                    AppConstants.intentKey.projectInfo:
                                        controller.projectInfo,
                                  };
                                  controller.moveToScreen(
                                      AppRoutes.addressListScreen, arguments);
                                } else if (controller.items[index].title ==
                                    "Check-In") {
                                  var arguments = {
                                    AppConstants.intentKey.projectId:
                                        controller.projectInfo?.id ?? 0 ?? 0,
                                  };
                                  controller.moveToScreen(
                                      AppRoutes.checkInRecordsScreen,
                                      arguments);
                                } else if (controller.items[index].title ==
                                    "Trades") {
                                  var arguments = {
                                    AppConstants.intentKey.projectId:
                                        controller.projectInfo?.id ?? 0 ?? 0,
                                  };
                                  controller.moveToScreen(
                                      AppRoutes.tradeRecordsScreen, arguments);
                                }
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Your main card
                                  CardViewDashboardItem(
                                    padding:
                                        EdgeInsets.fromLTRB(14, 12, 10, 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ImageUtils.setSvgAssetsImage(
                                            path: controller
                                                    .items[index].iconPath ??
                                                "",
                                            color: AppUtils.getColor(controller
                                                    .items[index].iconColor ??
                                                ""),
                                            width: 30,
                                            height: 30),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                controller.items[index].title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              if (controller.items[index]
                                                  .subtitle.isNotEmpty)
                                                Text(
                                                  controller
                                                      .items[index].subtitle,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if ((controller.items[index].badge != null) &&
                                      ((controller.items[index].badge ?? 0) >
                                          0))
                                    Positioned(
                                      top: -6,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${controller.items[index].badge}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
            bottomNavigationBar: CommonBottomNavigationBarWidget(),
          ),
        )));
  }

  List<Widget>? actionButtons() {
    return [
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
