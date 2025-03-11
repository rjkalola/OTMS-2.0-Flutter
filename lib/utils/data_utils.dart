
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/DashboardActionItemInfo.dart';
import 'app_constants.dart';

class DataUtils{
  static  List<String> titles = <String>[
    'home'.tr,
    'profile'.tr,
    'more'.tr,
  ];

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