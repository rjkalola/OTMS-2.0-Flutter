import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/dashboard/tabs/more_tab/controller/more_tab_repository.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/dashboard/controller/dashboard_controller.dart';
import 'package:belcka/pages/dashboard/models/dashboard_response.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_repository.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/model/local_permission_sequence_change_info.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/model/user_permissions_response.dart';
import 'package:belcka/pages/dashboard/view/dialogs/control_panel_menu_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';

class MoreTabController extends GetxController
    implements DialogButtonClickListener {
  final _api = MoreTabRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> logoutAPI() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();

    _api.logoutAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          Get.find<AppStorage>().clearAllData();
          Get.offAllNamed(AppRoutes.introductionScreen);
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {}
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void showLogoutDialog(){
    AlertDialogHelper.showAlertDialog(
        "",
        'logout_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.logout);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      Get.back();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      Get.back();
      logoutAPI();
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}
}
