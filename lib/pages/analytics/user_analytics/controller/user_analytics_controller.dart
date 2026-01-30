import 'dart:convert';
import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_repository.dart';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_grid_item.dart';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_model.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAnalyticsController extends GetxController implements DateFilterListener{
  final _api = UserAnalyticsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  int? userId = UserUtils.getLoginUserId();

  String startDate = "", endDate = "";
  final RxInt selectedDateFilterIndex = (1).obs;

  Rx<UserAnalyticsModel?> userAnalytics = Rx<UserAnalyticsModel?>(null);

  List<UserAnalyticsGridItem> menuItems(UserAnalyticsModel model) {
    return [
      UserAnalyticsGridItem(
        title: "Stopped work automatically",
        value:
        "${model.stoppedWorkAutomaticallyCount} Out of ${model.stoppedWorkAutomaticallyTotal}",
        action: "",
        iconData: Icons.warning_amber_rounded,
        color: Colors.red,
      ),
      UserAnalyticsGridItem(
        title: "Worth material used",
        value: "${model.currency}${model.worthMaterialUsed}",
        action: "",
        iconData: Icons.attach_money,
        color: Colors.teal,
      ),
      UserAnalyticsGridItem(
        title: "Late work started",
        value:
        "${model.lateWorkStartedCount} Out of ${model.lateWorkStartedTotal}",
        action: "",
        iconData: Icons.access_time,
        color: Colors.purple,
      ),
      UserAnalyticsGridItem(
        title: "Check-Ins",
        value: model.checkIns.toString(),
        action: "",
        iconData: Icons.login,
        color: Colors.purple,
      ),
      UserAnalyticsGridItem(
        title: "Leaves un-authorize",
        value: model.leaves.toString(),
        action: "",
        iconData: Icons.event_busy,
        color: Colors.purple,
      ),
      UserAnalyticsGridItem(
        title: "Outside working area",
        value:
        "${model.outsideWorkingArea} Out of ${model.outsideWorkingAreaTotal}",
        action: "",
        iconData: Icons.location_off,
        color: Colors.purple,
      ),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    getUserAnalyticsAPI();
  }
  //API Calls
  void getUserAnalyticsAPI() {
    isLoading.value = true;
    final Map<String, dynamic> map = {
      "user_id": 30,
      "start_date": "",
      "end_date": "",
    };
    _api.getUserAnalytics(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          try {
            final Map<String, dynamic> json =
            jsonDecode(responseModel.result!) as Map<String, dynamic>;
            userAnalytics.value = UserAnalyticsModel.fromJson(json);
            isMainViewVisible.value = true;
          } catch (e) {
            AppUtils.showSnackBarMessage(
                "Failed to parse analytics data");
          }
        }
        else{
          AppUtils.showSnackBarMessage(
            responseModel.statusMessage ?? "",
          );
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode ==
            ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  @override
  void onSelectDateFilter(
      int filterIndex, String filter,String startDate, String endDate, String dialogIdentifier) {
    //isResetEnable.value = true;
    startDate = startDate;
    endDate = endDate;
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
