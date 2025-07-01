import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/my_request/controller/my_request_repository.dart';
import 'package:otm_inventory/pages/my_request/model/my_request_info.dart';
import 'package:otm_inventory/pages/my_request/model/my_requests_list_response.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class MyRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _api = MyRequestRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  String startDate = "", endDate = "";

  final myRequestList = <MyRequestInfo>[].obs;
  List<MyRequestInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    getMyRequestsList();
  }

  void getMyRequestsList() async {
    Map<String, dynamic> map = {};
    if (!UserUtils.isAdmin()) {
      map["user_id"] = UserUtils.getLoginUserId();
    }
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;

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
      getMyRequestsList();
    }
  }
}
