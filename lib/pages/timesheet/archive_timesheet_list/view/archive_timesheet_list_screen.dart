import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/timesheet/archive_timesheet_list/controller/archive_timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/archive_timesheet_list/view/widgets/select_all_timesheet.dart';
import 'package:belcka/pages/timesheet/archive_timesheet_list/view/widgets/timesheet_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/toolbar_menu_item_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ArchiveTimesheetListScreen extends StatefulWidget {
  const ArchiveTimesheetListScreen({super.key});

  @override
  State<ArchiveTimesheetListScreen> createState() =>
      _ArchiveTimesheetListScreenState();
}

class _ArchiveTimesheetListScreenState extends State<ArchiveTimesheetListScreen>
    implements DateFilterListener {
  final controller = Get.put(ArchiveTimesheetListController());

  // @override
  // void initState() {
  //   super.initState();
  //  AppUtils.setStatusBarColor(); // restore on screen load
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'archived_timesheets'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
                onBackPressed: () {
                  controller.onBackPress();
                },
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
                            // controller.getUserListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              DateFilterOptionsHorizontalList(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                                startDate: controller.startDate,
                                endDate: controller.endDate,
                                listener: this,
                                selectedPosition:
                                    controller.selectedDateFilterIndex,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     GestureDetector(
                              //       onTap: () {
                              //         controller.clearFilter();
                              //       },
                              //       child: CardViewDashboardItem(
                              //         padding: EdgeInsets.fromLTRB(14, 2, 14, 2),
                              //         margin: EdgeInsets.only(
                              //             right: 12, bottom: 5, top: 2),
                              //         child: TitleTextView(
                              //           text: 'all'.tr,
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              SizedBox(
                                height: 6,
                              ),
                              SelectAllTimesheet(),
                              TimeSheetList(),
                              Visibility(
                                visible: controller.isChecked.value,
                                child: PrimaryButton(
                                    padding: EdgeInsets.all(16),
                                    buttonText: 'un_archive'.tr,
                                    onPressed: () {
                                      controller.unArchiveTimesheetApi(
                                          controller.getCheckedIds());
                                    }),
                              )
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          controller.moveToTimesheetFilters();
        },
        child: Padding(
          padding: EdgeInsets.all(2),
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor_(context)),
        ),
      ),
      // Visibility(
      //   visible: true,
      //   child: ToolbarMenuItemTextView(
      //     text: 'un_archive'.tr,
      //     textColor: defaultAccentColor_(context),
      //     padding: EdgeInsets.only(left: 6, right: 10),
      //     onTap: () {
      //
      //     },
      //   ),
      // ),
      SizedBox(
        width: 9,
      ),
    ];
  }

  @override
  void onSelectDateFilter(
      String startDate, String endDate, String dialogIdentifier) {
    // controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      controller.appliedFilters = {};
    }
    controller.loadTimesheetData(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
