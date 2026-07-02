import 'dart:convert';
import 'dart:ui';
import 'package:belcka/pages/analytics/user_score/model/user_analytics_score_model.dart';
import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class UserAnalyticsScoreController extends GetxController {
  final _api = UserAnalyticsScoreRepository();
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int? userId = UserUtils.getLoginUserId();

  String startDate = "", endDate = "";
  final RxInt selectedDateFilterIndex = (1).obs;
  final Rx<UserAnalyticsScoreModel?> analyticsScore =
      Rx<UserAnalyticsScoreModel?>(null);

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
    }
    setInitialDateFilter();
    getUserAnalyticsAPI();
  }

  void setInitialDateFilter() {
    selectedDateFilterIndex.value =
        Get.find<AppStorage>().getTimesheetDateFilterIndex();
    _applyDatesFromFilterIndex();
  }

  void _applyDatesFromFilterIndex() {
    final index = selectedDateFilterIndex.value;
    if (index <= 0 || index >= DataUtils.dateFilterList.length) return;

    final filter = DataUtils.dateFilterList[index];
    if (filter == "Reset" || filter == "Custom") return;

    final listDates = DateUtil.getDateWeekRange(filter);
    startDate = DateUtil.dateToString(listDates[0], DateUtil.DD_MM_YYYY_SLASH);
    endDate = DateUtil.dateToString(listDates[1], DateUtil.DD_MM_YYYY_SLASH);
  }

  Future<void> moveToScreen(String route, dynamic arguments) async {
    final result = await Get.toNamed(route, arguments: arguments);
    if (result != null && result) {
      getUserAnalyticsAPI();
    }
  }

  // API Calls
  void getUserAnalyticsAPI() {
    isInternetNotAvailable.value = false;
    isLoading.value = true;
    final Map<String, dynamic> map = {
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
            analyticsScore.value = UserAnalyticsScoreModel.fromJson(json);
            isMainViewVisible.value = true;
          } catch (e) {
            AppUtils.showSnackBarMessage("failed_to_parse_analytics_data".tr);
          }
        } else {
          AppUtils.showSnackBarMessage(
            responseModel.statusMessage ?? "",
          );
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Color scoreTextColor(num value) {
    if (value < 25) return Color(0xFFF26B4D);
    if (value < 50) return Color(0xFF576F8F);
    if (value < 75) return Color(0xFF0956CA);
    return Color(0xFF20BE6B);
  }
}
