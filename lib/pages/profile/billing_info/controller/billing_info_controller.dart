import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_repository.dart';
import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:belcka/pages/profile/post_coder_search/view/post_coder_search_screen.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/pages/profile/personal_info//controller/personal_info_repository.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class BillingInfoController extends GetxController
    implements SelectPhoneExtensionListener,SelectItemListener, DialogButtonClickListener{
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final middleNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final postcodeController = TextEditingController().obs;
  final myAddressController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final nameOnUTRController = TextEditingController().obs;
  final utrController = TextEditingController().obs;
  final ninController = TextEditingController().obs;
  final nameOnAccountController = TextEditingController().obs;
  final bankNameController = TextEditingController().obs;
  final accountNumberController = TextEditingController().obs;
  final sortCodeController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs;
  final formKey = GlobalKey<FormState>();
  final _api = BillingInfoRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final billingInfo = BillingInfo().obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  var isShowSaveButton = true.obs;

  final isSaveEnabled = false.obs;
  Map<String, dynamic> initialData = {};

  final cisController = TextEditingController().obs;
  var cisValue = "20";
  final List<ModuleInfo> listCis = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      billingInfo.value = arguments[AppConstants.intentKey.billingInfo];
      billingInfo.value.userId = arguments[AppConstants.intentKey.userId];
      setInitData();
    }
    else{
      cisValue = "20";
      cisController.value.text = "$cisValue%";
    }
    setupCISData();
    billingInfo.value.companyId = ApiConstants.companyId;
    setupListeners();
  }
  void setupCISData(){
    listCis.insert(0, ModuleInfo(id: 20,name: "20%"));
    listCis.insert(1, ModuleInfo(id: 30,name: "30%"));
  }
  void setupListeners() {
    List<TextEditingController> controllers = [
      firstNameController.value,
      lastNameController.value,
      middleNameController.value,
      emailController.value,
      postcodeController.value,
      myAddressController.value,
      phoneController.value,
      nameOnUTRController.value,
      utrController.value,
      ninController.value,
      nameOnAccountController.value,
      bankNameController.value,
      accountNumberController.value,
      sortCodeController.value,
    ];
    for (var c in controllers) {
      c.addListener(checkForChanges);
    }
    // extension listener
    ever(mExtension, (_) => checkForChanges());
  }
  void checkForChanges() {
    final currentData = {
      "firstName": firstNameController.value.text.trim(),
      "lastName": lastNameController.value.text.trim(),
      "middleName": middleNameController.value.text.trim(),
      "email": emailController.value.text.trim(),
      "postCode": postcodeController.value.text.trim(),
      "address": myAddressController.value.text.trim(),
      "phone": phoneController.value.text.trim(),
      "nameOnUtr": nameOnUTRController.value.text.trim(),
      "utrNumber": utrController.value.text.trim(),
      "ninNumber": ninController.value.text.trim(),
      "nameOnAccount": nameOnAccountController.value.text.trim(),
      "bankName": bankNameController.value.text.trim(),
      "accountNumber": accountNumberController.value.text.trim(),
      "shortCode": sortCodeController.value.text.trim(),
      "extension": mExtension.value,
      'cis':cisValue,
    };
    isSaveEnabled.value = jsonEncode(initialData) != jsonEncode(currentData);
  }
  void setInitData() {
    firstNameController.value.text = billingInfo.value.firstName ?? "";
    lastNameController.value.text = billingInfo.value.lastName ?? "";
    middleNameController.value.text = billingInfo.value.middleName ?? "";
    emailController.value.text = billingInfo.value.email ?? "";
    postcodeController.value.text = billingInfo.value.postCode ?? "";
    myAddressController.value.text = billingInfo.value.address ?? "";
    phoneController.value.text = billingInfo.value.phone ?? "";
    nameOnUTRController.value.text = billingInfo.value.nameOnUtr ?? "";
    utrController.value.text = billingInfo.value.utrNumber ?? "";
    ninController.value.text = billingInfo.value.ninNumber ?? "";
    nameOnAccountController.value.text = billingInfo.value.nameOnAccount ?? "";
    bankNameController.value.text = billingInfo.value.bankName ?? "";
    accountNumberController.value.text = billingInfo.value.accountNo ?? "";
    sortCodeController.value.text = billingInfo.value.shortCode ?? "";

    cisValue = billingInfo.value.cis ?? "";
    cisController.value.text = "$cisValue%";

    if (billingInfo.value.extension != null){
      mExtension.value = billingInfo.value.extension ?? "";
    }
    mFlag.value = AppUtils.getFlagByExtension(mExtension.value);

    //Store initial values for comparison
    initialData = {
      "firstName": firstNameController.value.text,
      "lastName": lastNameController.value.text,
      "middleName": middleNameController.value.text,
      "email": emailController.value.text,
      "postCode": postcodeController.value.text,
      "address": myAddressController.value.text,
      "phone": phoneController.value.text,
      "nameOnUtr": nameOnUTRController.value.text,
      "utrNumber": utrController.value.text,
      "ninNumber": ninController.value.text,
      "nameOnAccount": nameOnAccountController.value.text,
      "bankName": bankNameController.value.text,
      "accountNumber": accountNumberController.value.text,
      "shortCode": sortCodeController.value.text,
      "extension": mExtension.value,
      'cis':cisValue,
    };
  }
  void addBillingInfoAPI() async {
    // Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    // map["supervisor_id"] = supervisorId;
    // map["name"] = StringHelper.getText(teamNameController.value);
    // map["team_member_ids"] =
    //     UserUtils.getCommaSeparatedIdsString(teamMembersList);
    isLoading.value = true;
    _api.addBillingInfo(
      data: jsonEncode(billingInfo),
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
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void updateBillingInfoAPI() async {
    // Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    // map["supervisor_id"] = supervisorId;
    // map["name"] = StringHelper.getText(teamNameController.value);
    // map["team_member_ids"] =
    //     UserUtils.getCommaSeparatedIdsString(teamMembersList);
    isLoading.value = true;
    _api.updateBillingInfo(
      data: jsonEncode(billingInfo),
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
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void onSubmit() {
    if (valid()) {
      billingInfo.value.firstName =
          StringHelper.getText(firstNameController.value);
      billingInfo.value.lastName =
          StringHelper.getText(lastNameController.value);
      billingInfo.value.middleName =
          StringHelper.getText(middleNameController.value);
      billingInfo.value.email = StringHelper.getText(emailController.value);
      billingInfo.value.extension = mExtension.value;
      billingInfo.value.phone = StringHelper.getText(phoneController.value);
      billingInfo.value.postCode =
          StringHelper.getText(postcodeController.value);
      billingInfo.value.address =
          StringHelper.getText(myAddressController.value);
      billingInfo.value.nameOnUtr =
          StringHelper.getText(nameOnUTRController.value);
      billingInfo.value.utrNumber = StringHelper.getText(utrController.value);
      billingInfo.value.ninNumber = StringHelper.getText(ninController.value);
      billingInfo.value.nameOnAccount =
          StringHelper.getText(nameOnAccountController.value);
      billingInfo.value.bankName =
          StringHelper.getText(bankNameController.value);
      billingInfo.value.accountNo = StringHelper.getText(accountNumberController.value);
      billingInfo.value.shortCode =
          StringHelper.getText(sortCodeController.value);
      billingInfo.value.cis = cisValue;

      isShowSaveButton.value = false;

      if ((billingInfo.value.id ?? 0) != 0) {
        updateBillingInfoAPI();
      }
      else{
        addBillingInfoAPI();
      }
    }
  }
  bool valid() {
    return formKey.currentState!.validate();
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

  void searchPostCode() async {
    var arguments = {
      "post_code": postcodeController.value.text ?? "",
    };
    final result = await Get.toNamed(AppRoutes.postCoderSearchScreen, arguments: arguments);
    if (result != null) {
      print("Selected Summaryline: ${result['summaryline']}");
      print("Selected Postcode: ${result['postcode']}");
      myAddressController.value.text = result['summaryline'];
      postcodeController.value.text = result['postcode'];
      checkForChanges();
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
          isSearchEnable: false,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }
  void showCISList() {
    showDropDownDialog(AppConstants.dialogIdentifier.selectCategory,
        'select_cis'.tr, listCis, this);
  }
  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {
    mFlag.value = flag;
    mExtension.value = extension;
    billingInfo.value.extension = extension;
    checkForChanges();
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectCategory) {
       cisValue = "$id";
       cisController.value.text = name;
       checkForChanges();
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    // TODO: implement onNegativeButtonClicked
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    // TODO: implement onOtherButtonClicked
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    // TODO: implement onPositiveButtonClicked
  }
}
