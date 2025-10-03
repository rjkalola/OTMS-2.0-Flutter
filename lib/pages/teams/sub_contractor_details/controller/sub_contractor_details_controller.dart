import 'dart:convert';

import 'package:belcka/pages/teams/sub_contractor_details/controller/sub_contractor_details_repository.dart';
import 'package:belcka/pages/teams/sub_contractor_details/model/sub_contractor_details_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class SubContractorDetailsController extends GetxController {
  final _api = SubContractorDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final subContractorInfo = SubContractorInfo().obs;
  int teamId = 0, companyId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.teamId] ?? 0;
      companyId = arguments[AppConstants.intentKey.companyId] ?? 0;
    }
    getSubContractorDetailsDetailsApi();
  }

  void getSubContractorDetailsDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = companyId;
    map["team_id"] = teamId;
    _api.getSubContractorDetails(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          SubContractorDetailsResponse response =
              SubContractorDetailsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          subContractorInfo.value = response.info!;
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
}
