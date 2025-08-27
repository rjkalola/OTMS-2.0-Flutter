import 'dart:convert';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/notification_settings/controller/notification_setting_repository.dart';
import 'package:otm_inventory/pages/notification_settings/model/notification_category_info.dart';
import 'package:otm_inventory/pages/notification_settings/model/notification_settings_response.dart';
import 'package:otm_inventory/pages/notification_settings/model/save_notification_setting_request.dart';
import 'package:otm_inventory/pages/stock_filter/controller/stock_filter_repository.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_info.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_request.dart';
import 'package:otm_inventory/pages/stock_filter/model/stock_filter_response.dart';
import 'package:otm_inventory/pages/trades/controller/trades_repository.dart';
import 'package:otm_inventory/pages/trades/model/company_trades_response.dart';
import 'package:otm_inventory/pages/trades/model/save_trade_request.dart';
import 'package:otm_inventory/pages/trades/model/trade_info.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_storage.dart';
import '../../../web_services/response/response_model.dart';

class NotificationSettingController extends GetxController {
  final _api = NotificationSettingRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isCheckAll = false.obs;
  final notificationSettingList = <NotificationCategoryInfo>[].obs;
  int userId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
    }
    if (userId != 0) {
      getUserNotificationSettingsApi();
    } else {
      getCompanyNotificationSettingsApi();
    }
  }

  void getUserNotificationSettingsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = userId;
    _api.getUserNotificationSettings(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          NotificationSettingsResponse response =
              NotificationSettingsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          notificationSettingList.clear();
          notificationSettingList.addAll(response.info ?? []);
          checkSelectAll();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void getCompanyNotificationSettingsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getCompanyNotificationSettings(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          NotificationSettingsResponse response =
              NotificationSettingsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          notificationSettingList.clear();
          notificationSettingList.addAll(response.info ?? []);
          checkSelectAll();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  /*void changeCompanyBulkTradeStatusApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    // map["trade_id"] = tradeId;
    // map["status"] = status ? 1 : 0;
    map["trades"] = getRequestData();

    isLoading.value = true;
    _api.changeCompanyBulkTradeStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
        } else {
          // AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }*/

  List<SaveNotificationSettingRequest> getRequestData() {
    List<SaveNotificationSettingRequest> list = [];
    if (notificationSettingList.isNotEmpty) {
      for (var info in notificationSettingList) {
        for (var notificationInfo in info.notifications!) {
          list.add(SaveNotificationSettingRequest(
              notificationId: notificationInfo.id,
              isFeed: (notificationInfo.isFeed ?? false) ? 1 : 0,
              isPush: (notificationInfo.isPush ?? false) ? 1 : 0));
        }
      }
    }
    return list;
  }

  void checkSelectAll() {
    bool isAllSelected = true;
    for (var info in notificationSettingList) {
      for (var data in info.notifications!) {
        if ((data.isPush ?? false) == false ||
            (data.isFeed ?? false) == false) {
          isAllSelected = false;
          break;
        }
      }
      if (!isAllSelected) break;
    }

    isCheckAll.value = isAllSelected;
  }

  void checkAll() {
    isDataUpdated.value = true;
    isCheckAll.value = true;
    for (var info in notificationSettingList) {
      for (var data in info.notifications!) {
        data.isFeed = true;
        data.isPush = true;
      }
    }
    notificationSettingList.refresh();
  }

  void unCheckAll() {
    isDataUpdated.value = true;
    isCheckAll.value = false;
    for (var info in notificationSettingList) {
      for (var data in info.notifications!) {
        data.isFeed = false;
        data.isPush = false;
      }
    }
    notificationSettingList.refresh();
  }

  void onBackPress() {
    if (isDataUpdated.value) {
      // changeCompanyBulkTradeStatusApi();
    } else {
      Get.back();
    }
  }
}
