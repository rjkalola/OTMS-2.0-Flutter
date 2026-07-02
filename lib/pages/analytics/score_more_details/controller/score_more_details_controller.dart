import 'dart:convert';

import 'package:belcka/pages/analytics/score_more_details/controller/score_more_details_repository.dart';
import 'package:belcka/pages/analytics/score_more_details/model/score_settings_model.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class ScoreMoreDetailsController extends GetxController {
  final _api = ScoreMoreDetailsRepository();

  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final RxList<ScoreRangeModel> scoreRanges = <ScoreRangeModel>[].obs;

  num userScore = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userScore = arguments["score"] ?? 0;
    }
    getScoreSettingsAPI();
  }

  void getScoreSettingsAPI() {
    isInternetNotAvailable.value = false;
    isLoading.value = true;

    _api.getScoreSettings(
      queryParameters: {"company_id": ApiConstants.companyId},
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          try {
            final json =
                jsonDecode(responseModel.result!) as Map<String, dynamic>;
            final data = json['data'] as Map<String, dynamic>?;
            if (data != null) {
              scoreRanges.value =
                  ScoreSettingsModel.fromJson(data).ranges;
            }
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
