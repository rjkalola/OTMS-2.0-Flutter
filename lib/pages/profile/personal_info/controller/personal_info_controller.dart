import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/pages/profile/personal_info//controller/personal_info_repository.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';

class PersonalInfoController extends GetxController {
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final userCodeController = TextEditingController().obs;

  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs;
  final formKey = GlobalKey<FormState>();
  final _api = PersonalInfoRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  var isShowSaveButton = true.obs;

  final isSaveEnabled = false.obs;
  Map<String, dynamic> initialData = {};
  final userInfo = UserUtils.getUserInfo().obs;

  @override
  void onInit() {
    super.onInit();
    setInitData();
    setupListeners();
  }
  void setupListeners() {
    List<TextEditingController> controllers = [
      firstNameController.value,
      lastNameController.value,
      emailController.value,
      phoneController.value,
      userCodeController.value,
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
      "email": emailController.value.text.trim(),
      "phone": phoneController.value.text.trim(),
      "userCode": userCodeController.value.text.trim(),
      "extension": mExtension.value,
    };
    isSaveEnabled.value = jsonEncode(initialData) != jsonEncode(currentData);
  }
  void setInitData() {

    firstNameController.value.text = userInfo.value.firstName ?? "";
    lastNameController.value.text = userInfo.value.lastName ?? "";
    emailController.value.text = userInfo.value.email ?? "";
    phoneController.value.text = userInfo.value.phone ?? "";
    //userCodeController.value.text = userInfo.value.co ?? "";

    if (userInfo.value.extension != null){
      mExtension.value = userInfo.value.extension ?? "";
    }

    mFlag.value = AppUtils.getFlagByExtension(mExtension.value);

    //Store initial values for comparison
    initialData = {
      "firstName": firstNameController.value.text,
      "lastName": lastNameController.value.text,
      "email": emailController.value.text,
      "phone": phoneController.value.text,
      "userCode": userCodeController.value.text,
      "extension": mExtension.value,
    };
  }
  void onSubmit(){

  }

}
