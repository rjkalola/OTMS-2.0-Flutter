import 'dart:convert';

import 'package:belcka/pages/check_in/penalty/penalty_details/contoller/penalty_details_repository.dart';
import 'package:belcka/pages/check_in/penalty/penalty_details/model/penalty_info_response.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class PenaltyDetailsController extends GetxController
    implements DialogButtonClickListener {
  final _api = PenaltyDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final penaltyInfo = PenaltyInfo().obs;
  int penaltyId = 0;
  bool fromNotification = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      penaltyId = arguments[AppConstants.intentKey.penaltyId] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
    }
    getPenaltyDetailsApi();
  }

  void getPenaltyDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["penalty_id"] = penaltyId;
    _api.getPenaltyDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          PenaltyInfoResponse response =
              PenaltyInfoResponse.fromJson(jsonDecode(responseModel.result!));
          penaltyInfo.value = response.info!;
          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  // void deleteTeamApi() {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["team_id"] = teamId;
  //   _api.deleteTeam(
  //     queryParameters: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         BaseResponse response =
  //             BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //         Get.back(result: true);
  //       } else {
  //         AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         isInternetNotAvailable.value = true;
  //         // AppUtils.showApiResponseMessage('no_internet'.tr);
  //         // Utils.showApiResponseMessage('no_internet'.tr);
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showApiResponseMessage(error.statusMessage ?? "");
  //       }
  //     },
  //   );
  // }

  showDeleteTeamDialog(String dialogType) async {
    AlertDialogHelper.showAlertDialog(
        "",
        dialogType == AppConstants.dialogIdentifier.delete
            ? 'are_you_sure_you_want_to_delete'.tr
            : 'are_you_sure_you_want_to_remove'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        dialogType);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteTeam) {
      // deleteTeamApi();
      Get.back();
    }
    if (dialogIdentifier == AppConstants.dialogIdentifier.removeSubContractor) {
      // deleteSubContractorApi();
      Get.back();
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      // isDataUpdated.value = true;
      // getTeamDetailsApi();
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
