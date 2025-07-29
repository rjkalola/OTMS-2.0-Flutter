import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/authentication/signup2/controller/signup2_repository.dart';
import 'package:otm_inventory/pages/common/model/user_response.dart';
import 'package:otm_inventory/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/response/response_model.dart';

class SignUp2Controller extends GetxController
    implements SelectAttachmentListener {
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final imagePath = "".obs;
  UserInfo? userInfo;
  final _api = SignUp2Repository();

  @override
  void onInit() {
    super.onInit();
    getIntentData();
  }

  void getIntentData() {
    var arguments = Get.arguments;
    if (arguments != null) {
      userInfo = arguments[AppConstants.intentKey.userInfo];
      print("userInfo fist name:" + userInfo!.firstName!);
    }
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
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

  bool valid() {
    return !StringHelper.isEmptyString(imagePath.value);
  }

  void onSignUpClick() {
    if (valid()) {
      signUp();
    } else {
      AppUtils.showToastMessage('empty_image_selection'.tr);
    }
  }

  void signUp() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["first_name"] = userInfo?.firstName ?? "";
      map["last_name"] = userInfo?.lastName ?? "";
      // map["phone_extension_id"] = userInfo?.phoneExtensionId ?? 0;
      map["phone"] = userInfo?.phone ?? "";
      map["device_name"] = AppUtils.getDeviceName();
      map["latitude"] = "";
      map["longitude"] = "";
      map["address"] = "";
      multi.FormData formData = multi.FormData.fromMap(map);
      formData.files.add(
        MapEntry("image", await multi.MultipartFile.fromFile(imagePath.value)),
      );

      isLoading.value = true;
      _api.signUp(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.statusCode == 200) {
            UserResponse response =
                UserResponse.fromJson(jsonDecode(responseModel.result!));
            if (response.isSuccess!) {
              Get.find<AppStorage>().setUserInfo(response.info!);
              // Get.find<AppStorage>().setAccessToken(response.info!.apiToken!);
              // ApiConstants.accessToken = response.info!.apiToken!;
              // print("Token:" + ApiConstants.accessToken);
              AppUtils.saveLoginUser(response.info!);
              Get.offAllNamed(AppRoutes.joinCompanyScreen);
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
  }
}
