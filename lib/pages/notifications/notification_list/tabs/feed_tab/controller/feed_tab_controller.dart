import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/controller/feed_tab_repository.dart';
import 'package:belcka/pages/permissions/user_list/model/user_list_response.dart';
import 'package:belcka/pages/users/user_list/controller/user_list_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';

class FeedTabController extends GetxController {
  final _api = FeedTabRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final usersList = <UserInfo>[].obs;
  List<UserInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments;
    // if (arguments != null) {
    //   permissionId = arguments[AppConstants.intentKey.permissionId] ?? 0;
    // }
    // getUserListApi();
  }

  // void getUserListApi() {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["company_id"] = ApiConstants.companyId;
  //   _api.getUserList(
  //     data: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         UserListResponse response =
  //             UserListResponse.fromJson(jsonDecode(responseModel.result!));
  //         ImageUtils.preloadUserImages(response.info ?? []);
  //         tempList.clear();
  //         tempList.addAll(response.info ?? []);
  //         usersList.value = tempList;
  //         usersList.refresh();
  //         isMainViewVisible.value = true;
  //       } else {
  //         AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         isInternetNotAvailable.value = true;
  //         // AppUtils.showSnackBarMessage('no_internet'.tr);
  //         // Utils.showSnackBarMessage('no_internet'.tr);
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showSnackBarMessage(error.statusMessage ?? "");
  //       }
  //     },
  //   );
  // }

  void preloadUserImages(List<UserInfo> list) {
    for (var info in list) {
      final cache = CustomCacheManager();
      cache.downloadFile(info.userThumbImage ?? "");
    }
  }
}
