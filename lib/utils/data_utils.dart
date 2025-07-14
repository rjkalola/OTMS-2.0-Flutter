import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/dashboard_grid_item_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/model/DashboardActionItemInfo.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/week_day_info.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import 'app_constants.dart';

class DataUtils {
  static List<String> titles = <String>[
    'home'.tr,
    'profile'.tr,
    'more'.tr,
  ];

  // static List<IconData> tabIcons = [
  //   Icons.home_outlined,
  //   Icons.shopping_cart_outlined,
  //   Icons.pie_chart_outline,
  //   Icons.chat_bubble_outline,
  //   Icons.emoji_emotions_outlined,
  // ];

  static List<ModuleInfo> getControlPanelMenuItems() {
    var arrayItems = <ModuleInfo>[];

    arrayItems.add(ModuleInfo(
        name: 'widget'.tr,
        action: AppConstants.action.widgets,
        icon: Drawable.widgetIcon));
    arrayItems
        .add(ModuleInfo(name: 'notification'.tr, icon: Drawable.bellIcon));
    arrayItems.add(ModuleInfo(
        name: 'company_details'.tr,
        action: AppConstants.action.companyDetails,
        icon: Drawable.usersPermissionIcon));
    arrayItems.add(ModuleInfo(
        name: 'settings'.tr,
        action: AppConstants.action.settings,
        icon: Drawable.settingIcon));
    arrayItems.add(ModuleInfo(
        name: 'trades'.tr,
        action: AppConstants.action.companyTrades,
        icon: Drawable.tradesPermissionIcon));
    arrayItems
        .add(ModuleInfo(name: 'blank'.tr, icon: Drawable.chartPermissionIcon));
    arrayItems.add(ModuleInfo(
        name: 'user_permissions'.tr,
        action: AppConstants.action.userPermissions,
        icon: Drawable.permissionIcon));

    return arrayItems;
  }

  static List<ModuleInfo> getPhoneExtensionList() {
    var arrayItems = <ModuleInfo>[];

    ModuleInfo? info;

    info = ModuleInfo();
    info.id = 0;
    info.name = "United Kingdom";
    info.phoneExtension = "+44";
    info.flagImage = "assets/country_flag/gb.svg";
    arrayItems.add(info);

    info = ModuleInfo();
    info.id = 0;
    info.name = "India";
    info.phoneExtension = "+91";
    info.flagImage = "assets/country_flag/in.svg";
    arrayItems.add(info);

    info = ModuleInfo();
    info.id = 0;
    info.name = "United States of America";
    info.phoneExtension = "+1";
    info.flagImage = "assets/country_flag/us.svg";
    arrayItems.add(info);

    return arrayItems;
  }

  static List<String> tabIcons = [
    Drawable.tab1Icon,
    Drawable.tab2Icon,
    // Drawable.tab3Icon,
    Drawable.tab4Icon,
    Drawable.tab5Icon,
  ];

  static List<String> tabLabels = [
    'Home',
    'Cart',
    // 'Stats',
    'Chat',
    'Profile',
  ];

  static List<String> listColors = [
    '#FF7F00',
    '#007AFF',
    '#7523D3',
    '#CB4646DD',
  ];

  static PermissionInfo getEditWidget() {
    return PermissionInfo(
        name: 'edit_widget'.tr,
        slug: "edit_widget",
        permissionId: -1,
        icon: "edit_widget.svg");
  }

  static List<DashboardGridItemInfo> getDashboardGridItemsList() {
    var arrayItems = <DashboardGridItemInfo>[];

    DashboardGridItemInfo? info;

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "Team";
    info.subTitle = "Haringey Voids";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "Shift";
    info.subTitle = "4:30:22";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "Timesheets";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "My Analytics";
    info.subTitle = "83%";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.subTitle = "Add Widget";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 1";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 2";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 3";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 4";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 5";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 6";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 7";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 8";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 9";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    info = DashboardGridItemInfo();
    info.action = AppConstants.action.clockIn;
    info.title = "test 10";
    info.subTitle = "";
    info.icon = Drawable.timeClockImageTemp;
    info.iconColor = null;
    arrayItems.add(info);

    return arrayItems;
  }

  static List<DashboardActionItemInfo> getHeaderActionButtonsList() {
    var arrayItems = <DashboardActionItemInfo>[];

    DashboardActionItemInfo? info;

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.clockIn;
    info.title = "Clock In";
    info.image = "assets/images/ic_time_clock.svg";
    info.backgroundColor = "#ddeafb";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.quickTask;
    info.title = "Tasks";
    info.image = "assets/images/ic_task_dashboard.svg";
    info.backgroundColor = "#f8dbd6";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.map;
    info.title = "Map";
    info.image = "assets/images/ic_map.svg";
    info.backgroundColor = "#defff4";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.teams;
    info.title = "Teams";
    info.image = "assets/images/ic_teams.svg";
    info.backgroundColor = "#fce8df";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.users;
    info.title = "Users";
    info.image = "assets/images/ic_users_dashboard.svg";
    info.backgroundColor = "#fef9d1";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.timeSheet;
    info.title = "Timesheet";
    info.image = "assets/images/ic_dashboard_timesheet_button.svg";
    info.backgroundColor = "#e4d3f4";
    arrayItems.add(info);

    return arrayItems;
  }

  static List<List<DashboardActionItemInfo>> generateChunks(
      List<DashboardActionItemInfo> inList, int chunkSize) {
    List<List<DashboardActionItemInfo>> outList = [];
    List<DashboardActionItemInfo> tmpList = [];
    int counter = 0;

    for (int current = 0; current < inList.length; current++) {
      if (counter != chunkSize) {
        tmpList.add(inList[current]);
        counter++;
      }
      if (counter == chunkSize || current == inList.length - 1) {
        outList.add(tmpList.toList());
        tmpList.clear();
        counter = 0;
      }
    }
    return outList;
  }

  static List<WeekDayInfo> getWeekDays() {
    var arrayItems = <WeekDayInfo>[];
    arrayItems.add(WeekDayInfo(name: "monday", status: false));
    arrayItems.add(WeekDayInfo(name: "tuesday", status: false));
    arrayItems.add(WeekDayInfo(name: "wednesday", status: false));
    arrayItems.add(WeekDayInfo(name: "thursday", status: false));
    arrayItems.add(WeekDayInfo(name: "friday", status: false));
    arrayItems.add(WeekDayInfo(name: "saturday", status: false));
    arrayItems.add(WeekDayInfo(name: "sunday", status: false));

    /*  arrayItems.add(WeekDayInfo(name: "Monday", status: false));
    arrayItems.add(WeekDayInfo(name: "Tuesday", status: false));
    arrayItems.add(WeekDayInfo(name: "Wednesday", status: false));
    arrayItems.add(WeekDayInfo(name: "Thursday", status: false));
    arrayItems.add(WeekDayInfo(name: "Friday", status: false));
    arrayItems.add(WeekDayInfo(name: "Saturday", status: false));
    arrayItems.add(WeekDayInfo(name: "Sunday", status: false));*/
    return arrayItems;
  }

  static List<ModuleInfo> getModuleListFromUserList(List<UserInfo> userList) {
    var list = <ModuleInfo>[];
    for (var info in userList) {
      list.add(ModuleInfo(id: info.id, name: info.name));
    }
    return list;
  }

  static List<String> dateFilterList = [
    "Week",
    "Month",
    "3 Month",
    "6 Month",
    "Year",
    "Custom"
  ];

  static List<String> dateFilterListMyRequest = [
    "Week",
    "Month",
    "3 Month",
    "6 Month",
    "Year"
  ];

}
