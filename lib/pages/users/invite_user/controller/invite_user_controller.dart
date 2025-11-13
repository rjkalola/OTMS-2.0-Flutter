import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/listener/company_resources_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/users/invite_user/controller/invite_user_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/company_resources.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';

class InviteUserController extends GetxController
    implements
        SelectPhoneExtensionListener,
        CompanyResourcesListener,
        SelectItemListener {
  final phoneController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final teamController = TextEditingController().obs;
  final tradeController = TextEditingController().obs;
  final focusNodePhone = FocusNode().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs;
  final phoneNumberErrorMessage = "".obs;
  final formKey = GlobalKey<FormState>();

  final _api = InviteUserRepository();

  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final teamsList = <ModuleInfo>[].obs;
  final tradeList = <ModuleInfo>[].obs;
  int tradeId = 0, teamId = 0;

  @override
  void onInit() {
    super.onInit();
    loadResources(true);
  }

  void loadResources(bool isProgress) {
    isLoading.value = isProgress;
    CompanyResources.getResourcesApi(
        flag: AppConstants.companyResourcesFlag.teamList, listener: this);
  }

  @override
  void onCompanyResourcesResponse(bool isSuccess,
      CompanyResourcesResponse? response, String flag, bool isInternet) {
    if (isInternet) {
      if (isSuccess && response != null) {
        if (flag == AppConstants.companyResourcesFlag.teamList) {
          teamsList.addAll(response.info ?? []);
          CompanyResources.getResourcesApi(
              flag: AppConstants.companyResourcesFlag.tradeList,
              listener: this);
        } else if (flag == AppConstants.companyResourcesFlag.tradeList) {
          isLoading.value = false;
          isMainViewVisible.value = true;
          tradeList.addAll(response.info ?? []);
        }
      }
    } else {
      isInternetNotAvailable.value = true;
      // AppUtils.showApiResponseMessage('no_internet'.tr);
    }
  }

  void inviteUserApi() async {
    Map<String, dynamic> map = {};

    map["first_name"] = StringHelper.getText(firstNameController.value);
    map["last_name"] = StringHelper.getText(lastNameController.value);
    map["extension"] = mExtension.value;
    map["phone"] = StringHelper.getText(phoneController.value);
    map["device_type"] = AppConstants.deviceType;
    map["team_id"] = teamId;
    map["trade_id"] = tradeId;
    map["company_id"] = ApiConstants.companyId;

    isLoading.value = true;
    _api.inviteUser(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_country_code'.tr,
            list: DataUtils.getPhoneExtensionList(),
            listener: this),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {
    mFlag.value = flag;
    mExtension.value = extension;
    // mExtension.value = "+12345678";
    mExtensionId.value = id;
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }

  void showSelectTradeDialog() {
    if (tradeList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectTrade,
          'select_trade'.tr, tradeList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectTeamDialog() {
    if (teamsList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectTeam,
          'select_team'.tr, teamsList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
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
    if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeController.value.text = name;
      tradeId = id;
    } else if (action == AppConstants.dialogIdentifier.selectTeam) {
      teamController.value.text = name;
      teamId = id;
    }
  }

  void inviteUserClick() {
    if (formKey.currentState!.validate()) {
      inviteUserApi();
    }
  }

  @override
  void dispose() {
    focusNodePhone.value.dispose();
    super.dispose();
  }
}
