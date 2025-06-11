import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/teams/sub_contractor_details/controller/sub_contractor_details_repository.dart';
import 'package:otm_inventory/pages/teams/sub_contractor_details/model/sub_contractor_details_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class SubContractorDetailsController extends GetxController {
  final _api = SubContractorDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final subContractorInfo = SubContractorInfo().obs;
  int teamId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.teamId] ?? 0;
    }
    getSubContractorDetailsDetailsApi();
  }

  void getSubContractorDetailsDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
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
