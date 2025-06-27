import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/my_requests/controller/my_requests_repository.dart';
import 'package:otm_inventory/pages/my_requests/model/my_request_info.dart';
import 'package:otm_inventory/pages/my_requests/model/my_requests_list_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class MyRequestsController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final _api = MyRequestsRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;

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
    map["user_id"] = UserUtils.getLoginUserId();

    isLoading.value = true;
    _api.getMyRequestsList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

          MyRequestListResponse response =
          MyRequestListResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.requests ?? []);

          myRequestList.value = tempList;
          myRequestList.refresh();

          isMainViewVisible.value = true;
        }
        else{
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