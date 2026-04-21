import 'dart:convert';

import 'package:belcka/pages/analytics/kpi_analytics/controller/kpi_analytics_repository.dart';
import 'package:belcka/pages/analytics/kpi_analytics/model/kpi_analytics_model.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class KpiAnalyticsController extends GetxController {
  final _api = KpiAnalyticsRepository();

  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final RxInt selectedDateFilterIndex = (1).obs;
  final Rx<KpiAnalyticsModel?> kpiScore = Rx<KpiAnalyticsModel?>(null);

  int? userId = UserUtils.getLoginUserId();
  String startDate = "", endDate = "";

  String get dateRange {
    final data = kpiScore.value;
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
    getKpiAPI();
  }

  void getKpiAPI() {
    isInternetNotAvailable.value = false;
    isLoading.value = true;
    final query = {"start_date": startDate, "end_date": endDate};

    _api.getKpi(
      queryParameters: query,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          try {
            final json = jsonDecode(responseModel.result!);
            kpiScore.value = KpiAnalyticsModel.fromJson(json as Map<String, dynamic>);
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
