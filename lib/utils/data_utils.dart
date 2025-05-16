import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/dashboard_grid_item_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/model/DashboardActionItemInfo.dart';
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
    Drawable.tab3Icon,
    Drawable.tab4Icon,
    Drawable.tab5Icon,
  ];

  static List<String> tabLabels = [
    'Home',
    'Cart',
    'Stats',
    'Chat',
    'Profile',
  ];

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
}
