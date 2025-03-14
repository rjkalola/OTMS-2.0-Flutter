import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/models/permission_settings.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../pages/dashboard/models/dashboard_stock_count_response.dart';
import '../pages/stock_filter/model/stock_filter_response.dart';

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

  void setStoreId(int storeId) {
    storage.write(AppConstants.sharedPreferenceKey.storeId, storeId);
  }

  int getStoreId() {
    final storeId = storage.read(AppConstants.sharedPreferenceKey.storeId) ?? 0;
    return storeId;
  }

  void setStoreName(String storeName) {
    storage.write(AppConstants.sharedPreferenceKey.storeName, storeName);
  }

  String getStoreName() {
    final storeName =
        storage.read(AppConstants.sharedPreferenceKey.storeName) ?? "";
    return storeName;
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

  void clearAllData() {
    AppConstants.isResourcesLoaded = false;
    removeData(AppConstants.sharedPreferenceKey.storeId);
    removeData(AppConstants.sharedPreferenceKey.storeName);
    removeData(AppConstants.sharedPreferenceKey.userInfo);
    removeData(AppConstants.sharedPreferenceKey.accessToken);
    removeData(AppConstants.sharedPreferenceKey.dashboardItemCountData);
  }

  void removeData(String key) {
    storage.remove(key);
  }
}
