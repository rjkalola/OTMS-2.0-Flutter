import 'dart:convert';

import 'package:belcka/buyer_app/stores/add_store/controller/buyer_add_store_repository.dart';
import 'package:belcka/buyer_app/stores/store_list/models/store_info.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_repository.dart';
import 'package:belcka/pages/permissions/user_list/model/user_list_response.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerAddStoreController extends GetxController
    implements DialogButtonClickListener, SelectPhoneExtensionListener, SelectItemListener {
  final _api = BuyerAddStoreRepository();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final streetController = TextEditingController().obs;
  final locationController = TextEditingController().obs;
  final townController = TextEditingController().obs;
  final postcodeController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final phoneExtension = AppConstants.defaultPhoneExtension.obs;
  final phoneFlag = AppConstants.defaultFlagUrl.obs;

  final storeManagerController = TextEditingController().obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSaveEnable = false.obs,
      status = true.obs;

  int storeManagerId = 0;
  final userList = <UserInfo>[].obs;

  StoreInfo? itemDetails;

  @override
  void onInit() {
    super.onInit();
    getUserListApi();
    var arguments = Get.arguments;
    if (arguments != null) {
      itemDetails = arguments[AppConstants.intentKey.itemDetails];
      if (itemDetails != null) {
        nameController.value.text = itemDetails!.name ?? "";
        emailController.value.text = itemDetails!.email ?? "";
        streetController.value.text = itemDetails!.street ?? "";
        locationController.value.text = itemDetails!.location ?? "";
        townController.value.text = itemDetails!.town ?? "";
        postcodeController.value.text = itemDetails!.postcode ?? "";
        addressController.value.text = itemDetails!.address ?? "";
        phoneController.value.text = itemDetails!.phone ?? "";
        phoneExtension.value = itemDetails!.extension ?? phoneExtension.value;
        phoneFlag.value =
            AppUtils.getFlagByExtension(itemDetails!.extension ?? "");
        storeManagerController.value.text = itemDetails!.managerName ?? "";
        storeManagerId = itemDetails!.managerId ?? 0;
        status.value = itemDetails!.status ?? false;
      } else {
        isSaveEnable.value = true;
      }
    } else {
      isSaveEnable.value = true;
    }
  }

  void getUserListApi() {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    UserListRepository().getUserList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserListResponse response =
              UserListResponse.fromJson(jsonDecode(responseModel.result!));
          userList.value = response.info ?? [];
        }
      },
      onError: (ResponseModel error) {},
    );
  }

  void showDeleteDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  void deleteStoreApi() {
    if (itemDetails == null) {
      return;
    }
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["store_ids"] = (itemDetails?.id ?? 0).toString();
    _api.deleteStore(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
      },
    );
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
      deleteStoreApi();
      Get.back();
    }
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void addOrUpdateStoreApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = itemDetails?.id ?? 0;
    map["company_id"] = ApiConstants.companyId;
    map["name"] = StringHelper.getText(nameController.value);
    map["email"] = StringHelper.getText(emailController.value);
    map["street"] = StringHelper.getText(streetController.value);
    map["location"] = StringHelper.getText(locationController.value);
    map["town"] = StringHelper.getText(townController.value);
    map["postcode"] = StringHelper.getText(postcodeController.value);
    map["address"] = StringHelper.getText(addressController.value);
    map["phone"] = StringHelper.getText(phoneController.value);
    map["extension"] = phoneExtension.value;
    map["store_manager_id"] = storeManagerId;
    map["product_ids"] = itemDetails?.productIds ?? "";
    map["status"] = status.value.toString();

    _api.addOrUpdateStore(
      url: itemDetails != null
          ? ApiConstants.updateStore
          : ApiConstants.createStore,
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
    phoneFlag.value = flag;
    phoneExtension.value = extension;
    isSaveEnable.value = true;
  }

  void showSelectStoreManagerDialog() {
    if (userList.isNotEmpty) {
      showDropDownDialog(
          AppConstants.action.selectStoreManagerDialog,
          'store_manager'.tr,
          DataUtils.getModuleListFromUserList(userList),
          this);
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
    if (action == AppConstants.action.selectStoreManagerDialog) {
      isSaveEnable.value = true;
      storeManagerController.value.text = name;
      storeManagerId = id;
    }
  }

  void onBackPress() {
    Get.back();
  }
}
