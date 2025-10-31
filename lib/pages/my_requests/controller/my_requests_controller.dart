import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/my_requests/controller/my_requests_repository.dart';
import 'package:belcka/pages/my_requests/model/my_request_info.dart';
import 'package:belcka/pages/my_requests/model/my_requests_list_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRequestsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _api = MyRequestsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isResetEnable = false.obs;
  String startDate = "", endDate = "";

  final myRequestList = <MyRequestInfo>[].obs;
  List<MyRequestInfo> tempList = [];
  final RxInt selectedDateFilterIndex = (1).obs;
  Map<String, String> appliedFilters = {};
  final isFromMyProfile = false.obs;
  int? userId = 0;
  final isOtherUserProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    var arguments = Get.arguments;
    if (arguments != null) {
      isFromMyProfile.value = true;
      userId = arguments["user_id"] ?? 0;
      isOtherUserProfile.value = arguments["isOtherUserProfile"] ?? false;
    } else {
      isOtherUserProfile.value = false;
      isFromMyProfile.value = false;
      userId = UserUtils.getLoginUserId();
    }
    getMyRequestsList(appliedFilters);
  }

  void getMyRequestsList(Map<String, String> appliedFilters) async {
    Map<String, dynamic> map = {};
    if (isFromMyProfile.value == true) {
      map["user_id"] = userId; //UserUtils.getLoginUserId();
    }
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["filters"] = appliedFilters;

    isLoading.value = true;
    _api.getMyRequestsList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          MyRequestListResponse response =
              MyRequestListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.requests ?? []);

          myRequestList.value = tempList;
          myRequestList.refresh();

          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getMyRequestsList(appliedFilters);
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    appliedFilters = {};
    getMyRequestsList(appliedFilters);
  }
}
