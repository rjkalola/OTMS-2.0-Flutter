import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_repository.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class UpdateSignUpDetailsController extends GetxController
    implements SelectPhoneExtensionListener, SelectAttachmentListener {
  final phoneController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();
  final imagePath = "".obs;

  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    var user = UserUtils.getUserInfo();
    imagePath.value = user.userImage ?? "";
    firstNameController.value.text = user.firstName ?? "";
    lastNameController.value.text = user.lastName ?? "";
    phoneController.value.text = user.phone ?? "";
    mExtension.value = user.extension ?? "";
    mFlag.value = AppUtils.getFlagByExtension(user.extension ?? "");
  }

  void onSubmitClick() {
    if (valid()) {
      updateProfile();
    }
  }

  void updateProfile() async {
    Map<String, dynamic> map = {};
    map["first_name"] = StringHelper.getText(firstNameController.value);
    map["last_name"] = StringHelper.getText(lastNameController.value);
    map["extension"] = mExtension.value;
    map["phone"] = StringHelper.getText(phoneController.value);
    map["device_type"] = AppConstants.deviceType;
    map["user_id"] = UserUtils.getLoginUserId();

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());
    print("imagePath.value:" + imagePath.value.toString());

    if (!StringHelper.isEmptyString(imagePath.value) &&
        !imagePath.value.startsWith("http")) {
      formData.files.add(
        MapEntry(
            "user_image", await multi.MultipartFile.fromFile(imagePath.value)),
      );
    }

    isLoading.value = true;
    MyProfileDetailsRepository().updateProfile(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserResponse response =
              UserResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");
          Get.find<AppStorage>().setUserInfo(response.info!);
          AppUtils.saveLoginUser(response.info!);
          var arguments = {AppConstants.intentKey.fromSignUpScreen: true};
          Get.offAllNamed(AppRoutes.joinCompanyScreen, arguments: arguments);
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

  bool valid() {
    bool valid = false;
    valid = formKey.currentState!.validate();
    if (valid && StringHelper.isEmptyString(imagePath.value)) {
      valid = false;
      AppUtils.showSnackBarMessage('please_select_image'.tr);
    }
    return valid;
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

  showAttachmentOptionsDialog() async {
    print("pickImage");
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.attachmentType.camera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.attachmentType.image;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> path, String action) {
    if (action == AppConstants.attachmentType.camera ||
        action == AppConstants.attachmentType.image) {
      ManageAttachmentController().cropImage(path[0], this);
    } else if (action == AppConstants.attachmentType.croppedImage) {
      print("cropped path:" + path[0]);
      print("action:" + action);
      imagePath.value = path[0];
    }
  }

  void onBackPress() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }
}
