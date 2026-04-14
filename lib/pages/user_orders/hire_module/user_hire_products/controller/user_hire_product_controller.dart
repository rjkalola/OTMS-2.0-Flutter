import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/model/buyer_product_list_response.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/controller/user_hire_product_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_products_list_response.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_orders_list_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/hire_user_product_status.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHireProductController extends GetxController
    implements DialogButtonClickListener {
  final _api = UserHireProductRepository();
  static const String _dialogApprove = 'HIRE_REQUEST_APPROVE';
  static const String _dialogCancel = 'HIRE_REQUEST_CANCEL';
  static const String _dialogReturnLine = 'HIRE_PRODUCT_LINE_RETURN';

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;

  RxString startDate = ''.obs, endDate = ''.obs;
  RxInt selectedDateFilterIndex = (2).obs;

  final selectedTab = HireUserProductStatus.available.obs;
  final searchController = TextEditingController().obs;

  final productsList = <ProductInfo>[].obs;
  final listUiTick = 0.obs;
  List<ProductInfo> tempProductsList = [];

  final hireOrdersList = <HireOrderInfo>[].obs;
  List<HireOrderInfo> tempHireOrdersList = [];

  final hireProductsList = <ProductInfo>[].obs;
  List<ProductInfo> tempHireProductsList = [];
  int _pendingOrderId = 0;
  String _pendingProductIds = '';
  int _pendingStatus = 0;

  final ScrollController ordersScrollController = ScrollController();

  RxInt requestCount = 0.obs,
      hiredCount = 0.obs,
      availableCount = 0.obs,
      inServiceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? '';

      if (selectedTabType == AppConstants.type.request) {
        selectedTab.value = HireUserProductStatus.request;
      } else if (selectedTabType == AppConstants.type.hired) {
        selectedTab.value = HireUserProductStatus.hired;
      } else if (selectedTabType == AppConstants.type.available) {
        selectedTab.value = HireUserProductStatus.available;
      } else if (selectedTabType == AppConstants.type.inService) {
        selectedTab.value = HireUserProductStatus.inService;
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

  String _hireOrdersAllStatusesParam() {
    final h = AppConstants.hireStatus;
    return '${h.request},${h.hired},${h.inService}';
  }

  String _hireOrdersStatusParam() {
    final h = AppConstants.hireStatus;
    switch (selectedTab.value) {
      case HireUserProductStatus.request:
        return h.request.toString();
      case HireUserProductStatus.hired:
        return h.hired.toString();
      case HireUserProductStatus.inService:
        return h.inService.toString();
      case HireUserProductStatus.available:
        return '';
    }
  }

  void _updateHireTabCountsFromResponse(HireOrdersListResponse response) {
    requestCount.value = response.requested ?? 0;
    hiredCount.value = response.hired ?? 0;
    inServiceCount.value = response.serviced ?? 0;
  }

  void _updateHireTabCountsFromProductsResponse(HireProductsListResponse r) {
    requestCount.value = r.requested ?? 0;
    hiredCount.value = r.hired ?? 0;
    inServiceCount.value = r.serviced ?? 0;
  }

  void loadData() {
    clearSearch();
    isSearchEnable.value = false;
    if (selectedTab.value == HireUserProductStatus.available) {
      _loadAvailableTabData();
    } else {
      getHireOrdersListApi();
    }
  }

  /// Products list + hire order tab counts (same API as “All” filter) in parallel.
  void _loadAvailableTabData() {
    isLoading.value = true;
    var pending = 2;

    void finishOne() {
      pending--;
      if (pending <= 0) {
        isLoading.value = false;
      }
    }

    _api.getHireProducts(
      queryParameters: {'company_id': ApiConstants.companyId},
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          final response = BuyerProductListResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempProductsList = response.info ?? [];
          productsList.assignAll(tempProductsList);
          availableCount.value = tempProductsList.length;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        finishOne();
      },
      onError: (ResponseModel error) {
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
        finishOne();
      },
    );

    _fetchHireOrderTabCountsOnly(finishOne);
  }

  /// Updates tab counts from list API.
  void _fetchHireOrderTabCountsOnly(void Function() onDone) {
    _api.getHireOrdersList(
      queryParameters: {
        'company_id': ApiConstants.companyId,
        'start_date': startDate.value,
        'end_date': endDate.value,
        'status': _hireOrdersAllStatusesParam(),
        'user_id': UserUtils.getLoginUserId(),
      },
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response = HireOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));
          _updateHireTabCountsFromResponse(response);
        }
        onDone();
      },
      onError: (_) {
        onDone();
      },
    );
  }

  void notifyProductItemChanged() {
    listUiTick.value++;
    productsList.assignAll(List<ProductInfo>.from(productsList));
  }

  void getHireOrdersListApi() {
    if (selectedTab.value == HireUserProductStatus.hired ||
        selectedTab.value == HireUserProductStatus.inService) {
      getHireOrderProductsApi();
      return;
    }

    isLoading.value = true;
    final status = _hireOrdersStatusParam();
    Map<String, dynamic> map = {
      'company_id': ApiConstants.companyId,
      'start_date': startDate.value,
      'end_date': endDate.value,
      'status': status,
      'user_id': UserUtils.getLoginUserId(),
    };

    _api.getHireOrdersList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          final response = HireOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));

          _updateHireTabCountsFromResponse(response);

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

  void getHireOrderProductsApi() {
    isLoading.value = true;
    final h = AppConstants.hireStatus;
    final status = selectedTab.value == HireUserProductStatus.hired
        ? h.hired
        : h.inService;

    _api.getHireOrderProducts(
      queryParameters: {
        'company_id': ApiConstants.companyId,
        'status': status,
        'user_id': UserUtils.getLoginUserId(),
      },
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          final response = HireProductsListResponse.fromJson(
              jsonDecode(responseModel.result!));
          _updateHireTabCountsFromProductsResponse(response);
          tempHireProductsList = List<ProductInfo>.from(response.info ?? []);
          hireProductsList.assignAll(tempHireProductsList);
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
    if (selectedTab.value == HireUserProductStatus.available) {
      if (value.isEmpty) {
        productsList.assignAll(tempProductsList);
      } else {
        String query = value.toLowerCase();
        productsList.assignAll(tempProductsList
            .where((element) =>
                (element.shortName != null &&
                    element.shortName!.toLowerCase().contains(query)) ||
                (element.uuid != null &&
                    element.uuid!.toLowerCase().contains(query)))
            .toList());
      }
      productsList.refresh();
      return;
    }

    if (selectedTab.value == HireUserProductStatus.hired ||
        selectedTab.value == HireUserProductStatus.inService) {
      if (value.isEmpty) {
        hireProductsList.assignAll(tempHireProductsList);
      } else {
        final query = value.toLowerCase();
        hireProductsList.assignAll(tempHireProductsList.where((e) {
          return (!StringHelper.isEmptyString(e.shortName) &&
                  e.shortName!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(e.uuid) &&
                  e.uuid!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(e.userName) &&
                  e.userName!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(e.supplierName) &&
                  e.supplierName!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(e.orderId) &&
                  e.orderId!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(e.orderStatusText) &&
                  e.orderStatusText!.toLowerCase().contains(query));
        }).toList());
      }
      hireProductsList.refresh();
      return;
    }

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
    final fromRequest = selectedTab.value == HireUserProductStatus.request;
    final dynamic result = await Get.toNamed(
      AppRoutes.userHireOrderDetailsScreen,
      arguments: {
        AppConstants.intentKey.orderId: order.id ?? 0,
        AppConstants.intentKey.fromRequest: fromRequest,
        if (fromRequest) AppConstants.intentKey.hireRequestShowApprove: false,
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
      selectedTab.value = HireUserProductStatus.request;
    } else if (status == h.hired) {
      selectedTab.value = HireUserProductStatus.hired;
    } else if (status == h.inService) {
      selectedTab.value = HireUserProductStatus.inService;
    } else if (status == h.available) {
      selectedTab.value = HireUserProductStatus.available;
    } else if (status == h.cancelled) {
      selectedTab.value = HireUserProductStatus.request;
    }
  }

  Future<void> onHireProductLineClick(int index) async {
    final line = hireProductsList[index];
    final dynamic result = await Get.toNamed(
      AppRoutes.userHireOrderDetailsScreen,
      arguments: {
        AppConstants.intentKey.orderId: line.orderIdInt ?? 0,
        AppConstants.intentKey.projectId: line.productId ?? 0,
        AppConstants.intentKey.fromRequest: false,
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

  void onHireProductLineReturnTap(int index) {
    final line = hireProductsList[index];
    if ((line.orderIdInt ?? 0) <= 0 || (line.productId ?? 0) <= 0) return;
    _showRequestActionDialog(
      orderId: line.orderIdInt ?? 0,
      productIds: line.productId!.toString(),
      status: AppConstants.hireStatus.inService,
      message: 'are_you_sure_you_want_to_return_hire'.tr,
      dialogIdentifier: _dialogReturnLine,
    );
  }

  void onRequestOrderApproveProductLine(int orderIndex, int productIndex) {
    final order = hireOrdersList[orderIndex];
    final products = order.products;
    if (products == null ||
        productIndex < 0 ||
        productIndex >= products.length) {
      return;
    }
    final productId = products[productIndex].productId ?? 0;
    if ((order.id ?? 0) <= 0 || productId <= 0) return;
    _showRequestActionDialog(
      orderId: order.id ?? 0,
      productIds: productId.toString(),
      status: AppConstants.hireStatus.hired,
      message: 'are_you_sure_you_want_to_approve'.tr,
      dialogIdentifier: _dialogApprove,
    );
  }

  /// Request tab — cancel line item (wire API when available).
  void onRequestOrderCancelProductLine(int orderIndex, int productIndex) {
    final order = hireOrdersList[orderIndex];
    final products = order.products;
    if (products == null ||
        productIndex < 0 ||
        productIndex >= products.length) {
      return;
    }
    final productId = products[productIndex].productId ?? 0;
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
        if (_pendingStatus == AppConstants.hireStatus.inService)
          'need_service': false,
      },
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          String message = responseModel.statusMessage ?? '';
          final result = responseModel.result;
          if (result != null && result.isNotEmpty) {
            try {
              final baseResponse = BaseResponse.fromJson(jsonDecode(result));
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
        dialogIdentifier == _dialogCancel ||
        dialogIdentifier == _dialogReturnLine) {
      Get.back();
      _updateHireOrderStatusApi();
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == _dialogApprove ||
        dialogIdentifier == _dialogCancel ||
        dialogIdentifier == _dialogReturnLine) {
      Get.back();
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  Future<void> moveToCreateOrderScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result) {
      selectedTab.value = HireUserProductStatus.request;
      loadData();
    }
  }

  moveToScreen(String path, dynamic arguments) async {
    var result = await Get.toNamed(path, arguments: arguments);
    if (result != null && result) {
      loadData();
    }
  }
}
