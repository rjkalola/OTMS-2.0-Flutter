import 'dart:ffi';

import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';

class UserUtils {
  static int getLoginUserId() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    return info.id ?? 0;
  }

  static String getLoginUserName() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    return "${info.firstName} ${info.lastName}";
  }

  static bool isLoginUser(int? userId) {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    return (userId ?? 0) == (info.id ?? 0);
  }

  static bool isAdmin() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    int userRoleId = info.userRoleId ?? 0;
    return userRoleId == AppConstants.userType.admin;
  }

  static bool isEmployee() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.employee;
    return false;
  }

  static bool isManager() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.projectManager;
    return false;
  }

  static bool isSupervisor() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.supervisor;
    return false;
  }

  static List<UserInfo> getCheckedUserList(
      List<UserInfo> listTotalUsers, List<UserInfo> listCheckedUsers) {
    for (var info in listCheckedUsers) {
      for (var data in listTotalUsers) {
        if (data.id == info.id) {
          data.isCheck = true;
        }
      }
    }
    return listTotalUsers;
  }

  static String getCommaSeparatedIdsString(List<UserInfo> listCheckedUsers) {
    List<int> listIds = [];
    for (var info in listCheckedUsers) {
      listIds.add(info.id ?? 0);
    }
    return listIds.isNotEmpty ? listIds.join(',') : "";
  }

  static String getLoginUserRole() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    int userRoleId = info.userRoleId ?? 0;
    const Map<int, String> roleNames = {
      1: 'Admin',
      2: 'Project Manager',
      3: 'Supervisor',
      4: 'Employee',
      5: 'Driver',
    };
    return roleNames[userRoleId] ?? 'Unknown';
  }
}
