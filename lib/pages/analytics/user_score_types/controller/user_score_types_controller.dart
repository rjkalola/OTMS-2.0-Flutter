import 'dart:convert';
import 'dart:ui';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_grid_item.dart';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_model.dart';
import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_repository.dart';
import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_repository.dart';
import 'package:belcka/pages/analytics/user_score_types/model/user_score_warnings_model.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScoreTypesController extends GetxController{
  final _api = UserScoreTypesRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int? userId = UserUtils.getLoginUserId();

  String startDate = "", endDate = "";
  final RxInt selectedDateFilterIndex = (1).obs;
  Rx<UserAnalyticsModel?> userAnalytics = Rx<UserAnalyticsModel?>(null);

  final RxString dateRange = '01.Jan.25 – 31.Dec.25'.obs;

  final List<UserScoreWarningsModel> warningItems = [
    UserScoreWarningsModel(
      tag: 'Health & Safety',
      title: 'User without boots',
      date: '03 Sep 2025',
    ),
    UserScoreWarningsModel(
      tag: 'Health & Safety',
      title: 'Helmet not worn',
      date: '01 Sep 2025',
    ),
    UserScoreWarningsModel(
      tag: 'Operations',
      title: 'Unauthorized area access',
      date: '30 Aug 2025',
    ),
    UserScoreWarningsModel(
      tag: 'Safety',
      title: 'Reflective jacket missing',
      date: '28 Aug 2025',
    ),
  ];

  final userScoreType = UserScoreType.warnings.obs;
  String headerTitle = "warnings".tr;
  final kpiPercentage = 0;
  List<UserAnalyticsGridItem> kpiMenuItems(UserAnalyticsModel model) {
    return [
      UserAnalyticsGridItem(
        title: "Check-Ins",
        value: model.checkIns.toString(),
        action: "",
        iconData: Icons.login,
        color: Colors.purple,
      ),
    ];
  }

  final appActivityPercentage = 0;
  List<UserAnalyticsGridItem> appActivityMenuItems(UserAnalyticsModel model) {
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
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
      userScoreType.value = arguments["score_type"] ?? UserScoreType.warnings.obs;
    }
    if (userScoreType.value.value == 1){
      headerTitle = "warnings".tr;
    }
    else if (userScoreType.value.value == 2){
      headerTitle = "kpi".tr;
    }
    else if (userScoreType.value.value == 3) {
      headerTitle = "app_activity".tr;
    }

    //isMainViewVisible.value = true;
    getUserAnalyticsAPI();
  }

  Future<void> moveToScreen(String rout, dynamic arguments, String scoreType) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getUserAnalyticsAPI();
    }
  }
  //API Calls
  void getUserAnalyticsAPI() {
    isLoading.value = true;
    final Map<String, dynamic> map = {
      "user_id": userId,
      "start_date": startDate,
      "end_date": endDate,
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

  Color scoreTextColor(int value) {
    if (value < 25) return Color(0xFFF26B4D);
    if (value < 50) return Color(0xFF576F8F);
    if (value < 75) return Color(0xFF0956CA);
    return Color(0xFF65BB64);
  }
}
