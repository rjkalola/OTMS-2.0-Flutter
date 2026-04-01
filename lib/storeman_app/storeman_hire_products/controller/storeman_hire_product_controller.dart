import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_orders_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/storeman_app/storeman_hire_products/controller/storeman_hire_product_repository.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/hire_product_status.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanHireProductController extends GetxController
    implements DialogButtonClickListener {
  final _api = StoremanHireProductRepository();
  static const String _dialogApprove = 'STOREMAN_HIRE_REQUEST_APPROVE';
  static const String _dialogCancel = 'STOREMAN_HIRE_REQUEST_CANCEL';

  int _pendingOrderId = 0;
  String _pendingProductIds = '';
  int _pendingStatus = 0;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;

  RxString startDate = ''.obs, endDate = ''.obs;
  RxInt selectedDateFilterIndex = (-1).obs;

  final selectedTab = HireProductStatus.request.obs;
  final searchController = TextEditingController().obs;

  final hireOrdersList = <HireOrderInfo>[].obs;
  List<HireOrderInfo> tempHireOrdersList = [];

  final ScrollController ordersScrollController = ScrollController();

  RxInt requestCount = 0.obs,
      hiredCount = 0.obs,
      availableCount = 0.obs,
      serviceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? '';

      if (selectedTabType == AppConstants.type.request) {
        selectedTab.value = HireProductStatus.request;
      } else if (selectedTabType == AppConstants.type.hired) {
        selectedTab.value = HireProductStatus.hired;
      } else if (selectedTabType == AppConstants.type.available) {
        selectedTab.value = HireProductStatus.available;
      } else if (selectedTabType == AppConstants.type.servicing) {
        selectedTab.value = HireProductStatus.service;
      }

      selectedDateFilterIndex.value =
          arguments[AppConstants.intentKey.index] ?? -1;
      startDate.value = arguments[AppConstants.intentKey.startDate] ?? '';
      endDate.value = arguments[AppConstants.intentKey.endDate] ?? '';
    }
    loadData();
  }

  @override
  void onClose() {
    ordersScrollController.dispose();
    super.onClose();
  }

  String _hireOrdersStatusParam() {
    final h = AppConstants.hireStatus;
    switch (selectedTab.value) {
      case HireProductStatus.request:
        return h.request.toString();
      case HireProductStatus.hired:
        return h.hired.toString();
      case HireProductStatus.available:
        return h.available.toString();
      case HireProductStatus.service:
        return h.inService.toString();
    }
  }

  /// Tab badges from API aggregates on every successful list response (not tied to selected tab).
  void _updateTabCountsFromResponse(HireOrdersListResponse response) {
    requestCount.value = response.requested ?? 0;
    hiredCount.value = response.hired ?? 0;
    serviceCount.value = response.serviced ?? 0;
    availableCount.value = response.available ?? 0;
  }

  void loadData() {
    clearSearch();
    isSearchEnable.value = false;
    getHireOrdersListApi();
  }

  void getHireOrdersListApi() {
    isLoading.value = true;
    final status = _hireOrdersStatusParam();
    final map = <String, dynamic>{
      'company_id': ApiConstants.companyId,
      'start_date': startDate.value,
      'end_date': endDate.value,
      'status': status,
    };

    _api.getHireOrdersList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          final response = HireOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));
          _updateTabCountsFromResponse(response);
          tempHireOrdersList = List<HireOrderInfo>.from(response.info ?? []);
          hireOrdersList.assignAll(tempHireOrdersList);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void searchItem(String value) {
    if (value.isEmpty) {
      hireOrdersList.assignAll(tempHireOrdersList);
    } else {
      final query = value.toLowerCase();
      hireOrdersList.assignAll(tempHireOrdersList.where((element) {
        return (!StringHelper.isEmptyString(element.orderId) &&
                element.orderId!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.companyName) &&
                element.companyName!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.userName) &&
                element.userName!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.date) &&
                element.date!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.fullDate) &&
                element.fullDate!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.statusText) &&
                element.statusText!.toLowerCase().contains(query));
      }).toList());
    }
    hireOrdersList.refresh();
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem('');
  }

  Future<void> onHireOrderItemClick(int index) async {
    final order = hireOrdersList[index];
    final fromRequest = selectedTab.value == HireProductStatus.request;
    final dynamic result = await Get.toNamed(
      AppRoutes.userHireOrderDetailsScreen,
      arguments: {
        AppConstants.intentKey.orderId: order.id ?? 0,
        AppConstants.intentKey.fromRequest: fromRequest,
        if (fromRequest)
          AppConstants.intentKey.hireRequestShowApprove: true,
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

  void _selectTabFromHireApiStatus(int status) {
    final h = AppConstants.hireStatus;
    if (status == h.request) {
      selectedTab.value = HireProductStatus.request;
    } else if (status == h.hired) {
      selectedTab.value = HireProductStatus.hired;
    } else if (status == h.available) {
      selectedTab.value = HireProductStatus.available;
    } else if (status == h.inService) {
      selectedTab.value = HireProductStatus.service;
    } else if (status == h.cancelled) {
      selectedTab.value = HireProductStatus.request;
    }
  }

  void onRequestOrderApproveProductLine(int orderIndex, int productIndex) {
    final order = hireOrdersList[orderIndex];
    final products = order.products;
    if (products == null ||
        productIndex < 0 ||
        productIndex >= products.length) {
      return;
    }
    final productId = products[productIndex].id ?? 0;
    if ((order.id ?? 0) <= 0 || productId <= 0) return;
    _showRequestActionDialog(
      orderId: order.id ?? 0,
      productIds: productId.toString(),
      status: AppConstants.hireStatus.hired,
      message: 'are_you_sure_you_want_to_approve'.tr,
      dialogIdentifier: _dialogApprove,
    );
  }

  void onRequestOrderCancelProductLine(int orderIndex, int productIndex) {
    final order = hireOrdersList[orderIndex];
    final products = order.products;
    if (products == null ||
        productIndex < 0 ||
        productIndex >= products.length) {
      return;
    }
    final productId = products[productIndex].id ?? 0;
    if ((order.id ?? 0) <= 0 || productId <= 0) return;
    _showRequestActionDialog(
      orderId: order.id ?? 0,
      productIds: productId.toString(),
      status: AppConstants.hireStatus.cancelled,
      message: 'are_you_sure_you_want_to_cancel'.tr,
      dialogIdentifier: _dialogCancel,
    );
  }

  void _showRequestActionDialog({
    required int orderId,
    required String productIds,
    required int status,
    required String message,
    required String dialogIdentifier,
  }) {
    _pendingOrderId = orderId;
    _pendingProductIds = productIds;
    _pendingStatus = status;
    AlertDialogHelper.showAlertDialog(
      '',
      message,
      'yes'.tr,
      'no'.tr,
      '',
      true,
      false,
      this,
      dialogIdentifier,
    );
  }

  void _updateHireOrderStatusApi() {
    if (_pendingOrderId <= 0 ||
        _pendingStatus <= 0 ||
        StringHelper.isEmptyString(_pendingProductIds)) {
      return;
    }
    isLoading.value = true;
    _api.updateHireOrderStatus(
      data: {
        'company_id': ApiConstants.companyId,
        'id': _pendingOrderId,
        'status': _pendingStatus,
        'product_ids': _pendingProductIds,
      },
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          String message = responseModel.statusMessage ?? '';
          final result = responseModel.result;
          if (result != null && result.isNotEmpty) {
            try {
              final baseResponse =
                  BaseResponse.fromJson(jsonDecode(result));
              if (baseResponse.Message != null &&
                  baseResponse.Message!.isNotEmpty) {
                message = baseResponse.Message!;
              }
            } catch (_) {}
          }
          AppUtils.showApiResponseMessage(message);
          loadData();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == _dialogApprove ||
        dialogIdentifier == _dialogCancel) {
      Get.back();
      _updateHireOrderStatusApi();
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == _dialogApprove ||
        dialogIdentifier == _dialogCancel) {
      Get.back();
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}
}
