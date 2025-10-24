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

class OtherUserFullScreenImageViewController extends GetxController{

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;
  final imagePath = "".obs;

  @override
  void onInit() {
    super.onInit();

  }
}