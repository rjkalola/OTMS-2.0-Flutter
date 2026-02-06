import 'dart:convert';
import 'dart:ui';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_model.dart';
import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class UserAnalyticsScoreController extends GetxController{
  final _api = UserAnalyticsScoreRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int? userId = UserUtils.getLoginUserId();

  String startDate = "", endDate = "";
  final RxInt selectedDateFilterIndex = (1).obs;
  Rx<UserAnalyticsModel?> userAnalytics = Rx<UserAnalyticsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
    }
    getUserAnalyticsAPI();
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
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
    return Color(0xFF20BE6B);
  }
}
