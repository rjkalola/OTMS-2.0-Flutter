import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/models/permission_settings.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/local_permission_sequence_change_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/user_permissions_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../pages/dashboard/models/dashboard_stock_count_response.dart';

class AppStorage extends GetxController {
  final storage = GetStorage();
  static String uniqueId = "";

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void setUserInfo(UserInfo info) {
    storage.write(AppConstants.sharedPreferenceKey.userInfo, info.toJson());
  }

  UserInfo getUserInfo() {
    final map = storage.read(AppConstants.sharedPreferenceKey.userInfo) ?? {};
    return UserInfo.fromJson(map);
  }

  void setLoginUsers(List<UserInfo> list) {
    storage.write(
        AppConstants.sharedPreferenceKey.savedLoginUserList, jsonEncode(list));
  }

  List<UserInfo> getLoginUsers() {
    final jsonString =
        storage.read(AppConstants.sharedPreferenceKey.savedLoginUserList) ?? "";
    if (!StringHelper.isEmptyString(jsonString)) {
      final jsonMap = json.decode(jsonString);
      List<UserInfo> list = (jsonMap as List)
          .map((itemWord) => UserInfo.fromJson(itemWord))
          .toList();
      // List<UserInfo> list = (jsonDecode(jsonString) as List<dynamic>).cast<UserInfo>();
      return list;
    } else {
      return [];
    }
  }

  void setAccessToken(String token) {
    storage.write(AppConstants.sharedPreferenceKey.accessToken, token);
  }

  String getAccessToken() {
    final token =
        storage.read(AppConstants.sharedPreferenceKey.accessToken) ?? "";
    return token;
  }

  void setCompanyId(int companyId) {
    storage.write(AppConstants.sharedPreferenceKey.companyId, companyId);
  }

  int getCompanyId() {
    return storage.read(AppConstants.sharedPreferenceKey.companyId) ?? 0;
  }

  void setPermissions(PermissionSettings stockData) {
    storage.write(AppConstants.sharedPreferenceKey.permissionSettings,
        jsonEncode(stockData));
  }

  PermissionSettings getPermissions() {
    final stockData =
        storage.read(AppConstants.sharedPreferenceKey.permissionSettings) ?? "";
    PermissionSettings data = PermissionSettings();
    if (!StringHelper.isEmptyString(stockData)) {
      final jsonMap = json.decode(stockData);
      data = PermissionSettings.fromJson(jsonMap);
      return data;
    } else {
      return data;
    }
  }

  void setDashboardResponse(DashboardResponse data) {
    storage.write(
        AppConstants.sharedPreferenceKey.dashboardResponse, jsonEncode(data));
  }

  DashboardResponse getDashboardResponse() {
    final dashboardData =
        storage.read(AppConstants.sharedPreferenceKey.dashboardResponse) ?? "";
    DashboardResponse data = DashboardResponse();
    if (!StringHelper.isEmptyString(dashboardData)) {
      final jsonMap = json.decode(dashboardData);
      data = DashboardResponse.fromJson(jsonMap);
      return data;
    } else {
      return data;
    }
  }

  void setUserPermissionsResponse(UserPermissionsResponse? data) {
    storage.write(
        AppConstants.sharedPreferenceKey.userPermissionData, jsonEncode(data));
  }

  UserPermissionsResponse? getUserPermissionsResponse() {
    final dashboardData =
        storage.read(AppConstants.sharedPreferenceKey.userPermissionData) ?? "";
    UserPermissionsResponse data = UserPermissionsResponse();
    if (!StringHelper.isEmptyString(dashboardData)) {
      final jsonMap = json.decode(dashboardData);
      data = UserPermissionsResponse.fromJson(jsonMap);
      return data;
    } else {
      return null;
    }
  }

  void setLocalSequenceChangeData(
      List<LocalPermissionSequenceChangeInfo> data) {
    storage.write(AppConstants.sharedPreferenceKey.localSequenceChangeData,
        jsonEncode(data));
  }

  List<LocalPermissionSequenceChangeInfo> getLocalSequenceChangeData() {
    final jsonString = storage
            .read(AppConstants.sharedPreferenceKey.localSequenceChangeData) ??
        "";
    if (!StringHelper.isEmptyString(jsonString)) {
      final jsonMap = json.decode(jsonString);
      List<LocalPermissionSequenceChangeInfo> list = (jsonMap as List)
          .map((itemWord) =>
              LocalPermissionSequenceChangeInfo.fromJson(itemWord))
          .toList();
      // List<UserInfo> list = (jsonDecode(jsonString) as List<dynamic>).cast<UserInfo>();
      return list;
    } else {
      return [];
    }
  }

  void clearLocalSequenceChangeData() {
    removeData(AppConstants.sharedPreferenceKey.localSequenceChangeData);
  }

  void setLocalSequenceChanges(bool value) {
    storage.write(
        AppConstants.sharedPreferenceKey.isLocalSequenceChanged, value);
  }

  bool isLocalSequenceChanges() {
    return storage
            .read(AppConstants.sharedPreferenceKey.isLocalSequenceChanged) ??
        false;
  }

  void setDashboardStockCountData(DashboardStockCountResponse data) {
    storage.write(AppConstants.sharedPreferenceKey.dashboardItemCountData,
        jsonEncode(data));
  }

  DashboardStockCountResponse? getDashboardStockCountData() {
    final data =
        storage.read(AppConstants.sharedPreferenceKey.dashboardItemCountData) ??
            "";

    final jsonMap = json.decode(data);
    return DashboardStockCountResponse.fromJson(jsonMap);
  }

  void setWeeklySummeryCounter(bool value) {
    storage.write(
        AppConstants.sharedPreferenceKey.isWeeklySummeryCounter, value);
  }

  bool isWeeklySummeryCounter() {
    final value =
        storage.read(AppConstants.sharedPreferenceKey.isWeeklySummeryCounter) ??
            false;
    return value;
  }

  void setWeeklySummeryAmount(String value) {
    storage.write(AppConstants.sharedPreferenceKey.weeklySummeryAmount, value);
  }

  String getWeeklySummeryAmount() {
    final value =
        storage.read(AppConstants.sharedPreferenceKey.weeklySummeryAmount) ??
            "0";
    return value;
  }

  void setTimeLogId(String value) {
    storage.write(AppConstants.sharedPreferenceKey.timeLogId, value);
  }

  String getTimeLogId() {
    final value =
        storage.read(AppConstants.sharedPreferenceKey.timeLogId) ?? "0";
    return value;
  }

  void setCheckLogId(String value) {
    storage.write(AppConstants.sharedPreferenceKey.checkLogId, value);
  }

  String getCheckLogId() {
    final value =
        storage.read(AppConstants.sharedPreferenceKey.checkLogId) ?? "0";
    return value;
  }

  void setProjectId(String value) {
    storage.write(AppConstants.sharedPreferenceKey.projectId, value);
  }

  String getProjectId() {
    final value =
        storage.read(AppConstants.sharedPreferenceKey.projectId) ?? "0";
    return value;
  }

  void setShiftId(String value) {
    storage.write(AppConstants.sharedPreferenceKey.shiftId, value);
  }

  String getShiftId() {
    final value = storage.read(AppConstants.sharedPreferenceKey.shiftId) ?? "0";
    return value;
  }

  void setWorkLogId(int value) {
    storage.write(AppConstants.sharedPreferenceKey.workLogId, value);
  }

  int getWorkLogId() {
    final value =
        storage.read(AppConstants.sharedPreferenceKey.workLogId) ?? 0;
    return value;
  }

  void clearAllData() {
    AppConstants.isResourcesLoaded = false;
    ApiConstants.companyId = 0;
    ApiConstants.accessToken = "";
    removeData(AppConstants.sharedPreferenceKey.userInfo);
    removeData(AppConstants.sharedPreferenceKey.accessToken);
    removeData(AppConstants.sharedPreferenceKey.companyId);
    removeData(AppConstants.sharedPreferenceKey.dashboardItemCountData);
    removeData(AppConstants.sharedPreferenceKey.permissionSettings);
    removeData(AppConstants.sharedPreferenceKey.dashboardResponse);
    removeData(AppConstants.sharedPreferenceKey.isWeeklySummeryCounter);
    removeData(AppConstants.sharedPreferenceKey.weeklySummeryAmount);
    removeData(AppConstants.sharedPreferenceKey.userPermissionData);
    removeData(AppConstants.sharedPreferenceKey.localSequenceChangeData);
    removeData(AppConstants.sharedPreferenceKey.isLocalSequenceChanged);
    removeData(AppConstants.sharedPreferenceKey.workLogId);
  }

  void removeData(String key) {
    storage.remove(key);
  }
}
