import 'dart:convert';

import 'package:belcka/pages/analytics/app_activity_analytics/controller/app_activity_analytics_repository.dart';
import 'package:belcka/pages/analytics/app_activity_analytics/model/app_activity_analytics_model.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class AppActivityAnalyticsController extends GetxController {
  final _api = AppActivityAnalyticsRepository();

  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final RxInt selectedDateFilterIndex = (1).obs;
  final Rx<AppActivityAnalyticsModel?> appActivityScore =
      Rx<AppActivityAnalyticsModel?>(null);

  int? userId = UserUtils.getLoginUserId();
  String startDate = "", endDate = "";

  String get dateRange {
    final data = appActivityScore.value;
    if (data == null) return "";
    return "${data.startDate} - ${data.endDate}";
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? userId;
    }
    getAppActivityAPI();
  }

  void getAppActivityAPI() {
    isInternetNotAvailable.value = false;
    isLoading.value = true;
    final query = {
      "user_id": userId,
      "start_date": startDate,
      "end_date": endDate,
    };

    _api.getAppActivity(
      queryParameters: query,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          try {
            final json = jsonDecode(responseModel.result!);
            appActivityScore.value =
                AppActivityAnalyticsModel.fromJson(json as Map<String, dynamic>);
            isMainViewVisible.value = true;
          } catch (_) {
            AppUtils.showSnackBarMessage("failed_to_parse_analytics_data".tr);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }
}
