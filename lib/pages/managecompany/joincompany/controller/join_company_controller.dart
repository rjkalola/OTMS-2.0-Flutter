import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/controller/join_company_repository.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/model/get_companies_response.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/model/join_company_code_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class JoinCompanyController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  final selectCompanyController = TextEditingController().obs;
  final addCompanyCodeController = TextEditingController().obs;
  final _api = JoinCompanyRepository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final List<ModuleInfo> listCompanies = <ModuleInfo>[].obs;
  final companyId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getCompaniesApi();
  }

  void onSubmitClick() {
    // if (valid()) {
    // var userInfo = UserInfo();
    // userInfo.firstName = StringHelper.getText(firstNameController.value);
    // userInfo.lastName = StringHelper.getText(lastNameController.value);
    // userInfo.phone = StringHelper.getText(phoneController.value);
    // userInfo.phoneExtension = mExtension.value;
    // userInfo.phoneExtensionId = mExtensionId.value;
    // var arguments = {
    //   AppConstants.intentKey.userInfo: userInfo,
    // };
    // Get.toNamed(AppRoutes.signUp2Screen, arguments: arguments);
    // }
  }

  onClickSearch() {
    if (!StringHelper.isEmptyString(
        addCompanyCodeController.value.text.toString().trim())) {
      joinCompanyCode(
          "0", addCompanyCodeController.value.text.toString().trim());
    } else {
      showSnackBar('please_enter_company_code'.tr);
    }
  }

  void joinCompanyCode(String id, String code) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = id ?? "";
    map["code"] = code ?? "";
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.joinCompanyCode(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          JoinCompanyCodeResponse response = JoinCompanyCodeResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            if (!StringHelper.isEmptyList(response.trades)) {
              var arguments = {
                AppConstants.intentKey.companyData: response,
              };
              Get.toNamed(AppRoutes.selectCompanyTradeScreen, arguments: arguments);
            } else {

            }
          } else {
            showSnackBar(response.message!);
          }
        } else {
          showSnackBar(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          showSnackBar('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          showSnackBar(error.statusMessage!);
        }
      },
    );
  }

  void getCompaniesApi() {
    isLoading.value = true;
    _api.getCompanies(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          GetCompaniesResponse response =
              GetCompaniesResponse.fromJson(jsonDecode(responseModel.result!));
          if (!StringHelper.isEmptyList(response.info)) {
            listCompanies.addAll(response.info!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void scanInviteCodeCode(String code) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["code"] = code ?? "";
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.joinCompanyCode(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          JoinCompanyCodeResponse response = JoinCompanyCodeResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
          } else {
            showSnackBar(response.message!);
          }
        } else {
          showSnackBar(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          showSnackBar('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          showSnackBar(error.statusMessage!);
        }
      },
    );
  }

  void showCompanyListList() {
    if (listCompanies.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectCompany,
          'select_company'.tr, listCompanies, this);
    } else {
      AppUtils.showToastMessage('empty_company_list'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectCompany) {
      companyId.value = id;
      showJoinCompanyDialog();
    }
  }

  showJoinCompanyDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_join'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.joinCompany);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.joinCompany) {
      joinCompanyCode(companyId.toString(), "");
      Get.back();
    }
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
