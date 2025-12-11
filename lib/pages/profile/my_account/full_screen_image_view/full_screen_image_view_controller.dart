import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_repository.dart';
import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_repository.dart';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class FullScreenImageViewController extends GetxController
    implements SelectAttachmentListener {
  final _api = FullScreenImageViewRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final imagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  void updateProfileAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());
    print("imagePath.value:" + imagePath.value.toString());

    if (!StringHelper.isEmptyString(imagePath.value)) {
      formData.files.add(
        MapEntry(
            "user_image", await multi.MultipartFile.fromFile(imagePath.value)),
      );
    }

    isLoading.value = true;
    _api.updateProfile(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          UserResponse response =
              UserResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            Get.find<AppStorage>().setUserInfo(response.info!);
            print("Token:" + ApiConstants.accessToken);
            AppUtils.saveLoginUser(response.info!);
            Get.offAllNamed(AppRoutes.dashboardScreen);
            //Get.back(result: true);
          } else {
            AppUtils.showApiResponseMessage(response.message);
          }
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
      updateProfileAPI();
    }
  }
}
