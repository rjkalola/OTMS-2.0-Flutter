import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/listener/date_filter_listener.dart';
import 'package:otm_inventory/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/view/widgets/timesheet_list.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/view/widgets/week_number_title.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';
import 'package:otm_inventory/widgets/text/toolbar_menu_item_text_view.dart';

class TimeSheetListScreen extends StatefulWidget {
  const TimeSheetListScreen({super.key});

  @override
  State<TimeSheetListScreen> createState() => _TimeSheetListScreenState();
}

class _TimeSheetListScreenState extends State<TimeSheetListScreen>
    implements DateFilterListener {
  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return Obx(
      () => Container(
        color: dashBoardBgColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'timesheets'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                              child: DateFilterOptionsHorizontalList(
                                listener: this,
                              ),
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
          padding: const EdgeInsets.all(2),
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor),
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
  void onSelectDateFilter(String startDate, String endDate) {
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getTimeSheetListApi();
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
