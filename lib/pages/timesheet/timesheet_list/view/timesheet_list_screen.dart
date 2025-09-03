import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/widgets/timesheet_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/toolbar_menu_item_text_view.dart';

class TimeSheetListScreen extends StatefulWidget {
  const TimeSheetListScreen({super.key});

  @override
  State<TimeSheetListScreen> createState() => _TimeSheetListScreenState();
}

class _TimeSheetListScreenState extends State<TimeSheetListScreen>
    implements DateFilterListener {
  final controller = Get.put(TimeSheetListController());

  // @override
  // void initState() {
  //   super.initState();
  //  AppUtils.setStatusBarColor(); // restore on screen load
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'timesheets'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
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
                            TimeSheetList(),
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
      InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          List<ModuleInfo> listItems = [];
          for (var info in DataUtils.getWeekDays()) {
            listItems.add(ModuleInfo(
                name: StringHelper.capitalizeFirstLetter(info.name)));
          }
          controller.showMenuItemsDialog(context, listItems,
              AppConstants.dialogIdentifier.selectDayFilter);
        },
        child: Padding(
          padding:  EdgeInsets.all(2),
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor_(context)),
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
    controller.loadTimesheetData(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
