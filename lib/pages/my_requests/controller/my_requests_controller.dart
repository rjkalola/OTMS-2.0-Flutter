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
      isResetEnable = false.obs,
      isLoadingMore = false.obs;
  String startDate = "", endDate = "";

  final myRequestList = <MyRequestInfo>[].obs;
  List<MyRequestInfo> tempList = [];
  final RxInt selectedDateFilterIndex = (1).obs;
  Map<String, String> appliedFilters = {};
  final isFromMyProfile = false.obs;
  int? userId = 0;
  final isOtherUserProfile = false.obs;

  var currentPage = 1.obs;
  int limit = 20;
  var hasMoreData = true.obs;
  final ScrollController scrollController = ScrollController();

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
    getMyRequestsList(appliedFilters,isRefresh:true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && hasMoreData.value) {
          getMyRequestsList(appliedFilters);
        }
      }
    });
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getMyRequestsList(Map<String, String> appliedFilters,{bool isRefresh = false, String searchValue = ""}) async {

    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
    }
    if (!hasMoreData.value && !isRefresh) return;
    isLoading.value = true;

    if (currentPage.value == 1) {

    }
    else{
      isLoadingMore.value = true;
    }

    Map<String, dynamic> map = {};
    if (isFromMyProfile.value == true) {
      map["user_id"] = userId; //UserUtils.getLoginUserId();
    }
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["filters"] = appliedFilters;
    map["page"] = currentPage.value;
    map["limit"] = limit;
    map["search"] = searchValue;

    _api.getMyRequestsList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          MyRequestListResponse response =
              MyRequestListResponse.fromJson(jsonDecode(responseModel.result!));

          var newItems = response.requests ?? [];

          if (isRefresh) {
            tempList.clear();
          }

          if (response.pagination != null) {
            print("Total pages: ${response.pagination!.totalPages}");

            print("Current page: ${response.pagination!.currentPage}");

            if (currentPage.value >= response.pagination!.totalPages) {
              hasMoreData.value = false;
            }
            else{
              currentPage.value++;
            }
          }

          tempList.addAll(newItems);
          myRequestList.value = List.from(tempList);
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
      getMyRequestsList(appliedFilters,isRefresh: true);
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    appliedFilters = {};
    getMyRequestsList(appliedFilters,isRefresh: true);
  }
}
