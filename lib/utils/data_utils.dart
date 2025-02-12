
import 'package:get/get.dart';
import 'package:otm_inventory/utils/app_storage.dart';

import '../pages/dashboard/models/DashboardActionItemInfo.dart';
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
    info.id = AppConstants.action.items;
    info.title = 'products'.tr;
    info.image = "assets/images/ic_time_clock.svg";
    info.backgroundColor = "#ddeafb";
    arrayItems.add(info);

    // info = DashboardActionItemInfo();
    // info.id = AppConstants.action.store;
    // info.title = 'stores'.tr;
    // info.image = "assets/images/ic_time_clock.svg";
    // info.backgroundColor = "#f8dbd6";
    // arrayItems.add(info);

    // if(AppStorage.storeId != 0){
    //   info = DashboardActionItemInfo();
    //   info.id = AppConstants.action.stocks;
    //   info.title = 'stocks'.tr;
    //   info.image = "assets/images/ic_time_clock.svg";
    //   info.backgroundColor = "#ddeafb";
    //   arrayItems.add(info);
    // }

      // info = DashboardActionItemInfo();
      // info.id = AppConstants.action.vendors;
      // info.title = 'vendors'.tr;
      // info.image = "assets/images/ic_time_clock.svg";
      // info.backgroundColor = "#ddeafb";
      // arrayItems.add(info);

    // info = DashboardActionItemInfo();
    // info.id = AppConstants.action.manufacturer;
    // info.title = 'manufacturer'.tr;
    // info.image = "assets/images/ic_time_clock.svg";
    // info.backgroundColor = "#ddeafb";
    // arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.categories;
    info.title = 'categories'.tr;
    info.image = "assets/images/ic_time_clock.svg";
    info.backgroundColor = "#ddeafb";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.suppliers;
    info.title = 'suppliers'.tr;
    info.image = "assets/images/ic_time_clock.svg";
    info.backgroundColor = "#defff4";
    arrayItems.add(info);

    // info = DashboardActionItemInfo();
    // info.id = AppConstants.action.vendors;
    // info.title = "Vendors";
    // info.image = "assets/images/ic_time_clock.svg";
    // info.backgroundColor = "#defff4";
    // arrayItems.add(info);

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