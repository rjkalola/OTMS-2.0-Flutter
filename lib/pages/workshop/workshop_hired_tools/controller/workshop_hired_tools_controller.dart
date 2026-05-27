import 'dart:convert';

import 'package:belcka/pages/workshop/workshop_hired_tools/controller/workshop_hired_tools_repository.dart';
import 'package:belcka/pages/workshop/workshop_hired_tools/model/workshop_hired_tools_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkshopHiredToolsController extends GetxController {
  final _api = WorkshopHiredToolsRepository();

  final selectedStatus = AppConstants.hireStatus.hired.obs;
  final toolsList = <WorkshopHiredToolInfo>[].obs;
  final requestedCount = 0.obs;
  final hiredCount = 0.obs;
  final searchController = TextEditingController().obs;
  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final isSearchEnable = false.obs;

  List<WorkshopHiredToolInfo> tempToolsList = [];

  bool get isHiredTab => selectedStatus.value == AppConstants.hireStatus.hired;

  @override
  void onInit() {
    super.onInit();
    getWorkshopHiredToolsApi();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void selectHiredTab() {
    selectedStatus.value = AppConstants.hireStatus.hired;
    loadData();
  }

  void selectRequestedTab() {
    selectedStatus.value = AppConstants.hireStatus.request;
    loadData();
  }

  void loadData() {
    clearSearch();
    isSearchEnable.value = false;
    getWorkshopHiredToolsApi();
  }

  void getWorkshopHiredToolsApi() {
    isLoading.value = true;
    final map = <String, dynamic>{
      'team_ids': UserUtils.getSupervisorTeamIds(),
      'status': selectedStatus.value,
    };

    _api.getWorkshopHiredTools(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          isMainViewVisible.value = true;
          final response = WorkshopHiredToolsResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.isSuccess == true) {
            requestedCount.value = response.requested ?? 0;
            hiredCount.value = response.hired ?? 0;
            tempToolsList =
                List<WorkshopHiredToolInfo>.from(response.info ?? []);
            toolsList.assignAll(tempToolsList);
          } else {
            AppUtils.showSnackBarMessage(response.message ?? '');
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void searchItem(String value) {
    if (StringHelper.isEmptyString(value)) {
      toolsList.assignAll(tempToolsList);
      return;
    }

    final query = value.toLowerCase();
    toolsList.assignAll(tempToolsList.where((item) {
      return (!StringHelper.isEmptyString(item.shortName) &&
              item.shortName!.toLowerCase().contains(query)) ||
          (!StringHelper.isEmptyString(item.uuid) &&
              item.uuid!.toLowerCase().contains(query)) ||
          (!StringHelper.isEmptyString(item.userName) &&
              item.userName!.toLowerCase().contains(query)) ||
          (!StringHelper.isEmptyString(item.orderId) &&
              item.orderId!.toLowerCase().contains(query));
    }).toList());
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem('');
  }

  Future<void> onHireOrderItemClick(int orderId, {int productId = 0}) async {
    final fromRequest = selectedStatus.value == AppConstants.hireStatus.request;
    if (orderId != 0) {
      final dynamic result = await Get.toNamed(
        AppRoutes.userHireOrderDetailsScreen,
        arguments: {
          AppConstants.intentKey.orderId: orderId,
          if (fromRequest && productId != 0)
            AppConstants.intentKey.projectId: productId,
          AppConstants.intentKey.fromRequest: fromRequest,
          if (fromRequest) AppConstants.intentKey.hireRequestShowApprove: true,
        },
      );
      if (result != null && result is Map) {
        final ok = result[AppConstants.intentKey.result] == true;
        if (ok) {
          final status = result[AppConstants.intentKey.status] as int? ?? 0;
          _selectTabFromHireApiStatus(status);
          loadData();
        }
      }
    }
  }

  void _selectTabFromHireApiStatus(int status) {
    final h = AppConstants.hireStatus;
    if (status == h.request || status == h.cancelled) {
      selectedStatus.value = h.request;
    } else if (status == h.hired ||
        status == h.inService ||
        status == h.available) {
      selectedStatus.value = h.hired;
    }
  }
}
