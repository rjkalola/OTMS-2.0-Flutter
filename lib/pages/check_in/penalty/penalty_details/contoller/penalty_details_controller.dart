import 'dart:convert';

import 'package:belcka/pages/check_in/penalty/penalty_details/contoller/penalty_details_repository.dart';
import 'package:belcka/pages/check_in/penalty/penalty_details/model/penalty_info_response.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PenaltyDetailsController extends GetxController
    implements DialogButtonClickListener {
  final _api = PenaltyDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  RxInt status = 0.obs;
  final penaltyInfo = PenaltyInfo().obs;
  int penaltyId = 0;
  bool fromNotification = false;
  final noteController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();

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
          status.value = penaltyInfo.value.status ?? 0;
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

  void deletePenaltyApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["penalty_id"] = penaltyId;
    _api.deletePenalty(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
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

  void appealPenaltyApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["penalty_id"] = penaltyId;
    map["appeal_note"] = StringHelper.getText(noteController.value);
    _api.appealPenalty(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
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

  void approveRejectPenaltyApi(int status) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["appeal_id"] = penaltyInfo.value.appealId ?? 0;
    map["admin_note"] = StringHelper.getText(noteController.value);
    map["status"] = status; //1 for approve, 2 for reject
    _api.penaltyApproveReject(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          onBackPress();
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

  showActionDialog(String dialogType) async {
    AlertDialogHelper.showAlertDialog("", getActionDialogMessage(dialogType),
        'yes'.tr, 'no'.tr, "", true, false, this, dialogType);
  }

  String getActionDialogMessage(String dialogType) {
    if (dialogType == AppConstants.dialogIdentifier.delete) {
      return 'are_you_sure_you_want_to_delete'.tr;
    } else if (dialogType == AppConstants.dialogIdentifier.appeal) {
      return 'are_you_sure_you_want_to_appeal'.tr;
    } else if (dialogType == AppConstants.dialogIdentifier.approve) {
      return 'are_you_sure_you_want_to_approve'.tr;
    } else if (dialogType == AppConstants.dialogIdentifier.reject) {
      return 'are_you_sure_you_want_to_reject'.tr;
    } else {
      return "";
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      deletePenaltyApi();
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.appeal) {
      appealPenaltyApi();
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.approve) {
      approveRejectPenaltyApi(AppConstants.status.approved);
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.reject) {
      approveRejectPenaltyApi(AppConstants.status.rejected);
    }
    Get.back();
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      // isDataUpdated.value = true;
      // getTeamDetailsApi();
    }
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
