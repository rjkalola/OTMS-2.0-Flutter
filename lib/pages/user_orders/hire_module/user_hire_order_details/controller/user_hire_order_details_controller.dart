import 'dart:convert';

import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/controller/user_hire_order_details_repository.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/model/hire_order_detail_response.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/model/hire_order_update_status_response.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class UserHireOrderDetailsController extends GetxController
    implements DialogButtonClickListener {
  final _api = UserHireOrderDetailsRepository();
  static const String _dialogApprove = 'HIRE_DETAILS_APPROVE';
  static const String _dialogCancel = 'HIRE_DETAILS_CANCEL';
  static const String _dialogReturn = 'HIRE_DETAILS_RETURN';
  static const String _dialogAvailable = 'HIRE_DETAILS_AVAILABLE';
  static const String _dialogDamaged = 'HIRE_DETAILS_DAMAGED';

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final orderInfo = HireOrderInfo().obs;
  final productsList = <ProductInfo>[].obs;
  final isRequestFlow = false.obs;
  final needService = false.obs;

  final showHireRequestApprove = false.obs;

  int _orderId = 0;
  int _productId = 0;
  int _pendingStatus = 0;
  bool _shouldSendNeedService = false;
  bool fromFeed = false;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      _orderId = arguments[AppConstants.intentKey.orderId] ?? 0;
      _productId = arguments[AppConstants.intentKey.projectId] ?? 0;
      fromFeed = arguments[AppConstants.intentKey.fromNotification] ?? false;
      if (!fromFeed) {
        isRequestFlow.value =
            arguments[AppConstants.intentKey.fromRequest] == true;
        if (isRequestFlow.value) {
          showHireRequestApprove.value =
              arguments[AppConstants.intentKey.hireRequestShowApprove] == true;
        }
      }
    }
    if (_orderId > 0) {
      loadDetail();
    } else {
      AppUtils.showSnackBarMessage('empty_data_message'.tr);
    }
  }

  void loadDetail() {
    isLoading.value = true;
    _api.getHireOrderDetail(
      queryParameters: {
        'company_id': ApiConstants.companyId,
        if (_productId > 0) 'product_id': _productId,
        'id': _orderId,
      },
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response = HireOrderDetailResponse.fromJson(
              jsonDecode(responseModel.result!));
          orderInfo.value = response.info ?? HireOrderInfo();
          productsList.assignAll(orderInfo.value.products ?? []);
          if (fromFeed &&
              (orderInfo.value.status ?? 0) ==
                  AppConstants.hireStatus.request) {
            isRequestFlow.value = AppUtils.isAdmin();
            if (isRequestFlow.value) {
              showHireRequestApprove.value = true;
            }
          }
          isMainViewVisible.value = true;
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

  void onBackPress() {
    Get.back();
  }

  void onToggleProductSelection(int index, bool? value) {
    if (index < 0 || index >= productsList.length) return;
    productsList[index].isCheck = value == true;
    productsList.refresh();
  }

  void onRequestCancelSelectedTap() {
    _onRequestBulkActionTap(
      status: AppConstants.hireStatus.cancelled,
      confirmMessage: 'are_you_sure_you_want_to_cancel'.tr,
      dialogIdentifier: _dialogCancel,
    );
  }

  void onRequestApproveSelectedTap() {
    _onRequestBulkActionTap(
      status: AppConstants.hireStatus.hired,
      confirmMessage: 'are_you_sure_you_want_to_approve'.tr,
      dialogIdentifier: _dialogApprove,
    );
  }

  bool get isHiredStatus =>
      orderInfo.value.status == AppConstants.hireStatus.hired;

  bool get isInServiceStatus =>
      orderInfo.value.status == AppConstants.hireStatus.inService;

  void onReturnTap() {
    _shouldSendNeedService = true;
    _onAllProductsActionTap(
      status: AppConstants.hireStatus.inService,
      confirmMessage: 'are_you_sure_you_want_to_return_hire'.tr,
      dialogIdentifier: _dialogReturn,
    );
  }

  void onAvailableToHireTap() {
    _shouldSendNeedService = false;
    _onAllProductsActionTap(
      status: AppConstants.hireStatus.available,
      confirmMessage: 'Are you sure you want to mark as Available To Hire?',
      dialogIdentifier: _dialogAvailable,
    );
  }

  void onDamagedTap() {
    _shouldSendNeedService = false;
    _onAllProductsActionTap(
      status: AppConstants.hireStatus.damaged,
      confirmMessage: 'Are you sure you want to mark as Damaged?',
      dialogIdentifier: _dialogDamaged,
    );
  }

  void onNeedServiceChanged(bool? value) {
    needService.value = value == true;
  }

  void _onAllProductsActionTap({
    required int status,
    required String confirmMessage,
    required String dialogIdentifier,
  }) {
    final productIds = productsList
        .where((e) => (e.productId ?? 0) > 0)
        .map((e) => e.productId!.toString())
        .toList();
    if (productIds.isEmpty) {
      AppUtils.showToastMessage('msg_select_at_least_one_item'.tr);
      return;
    }
    _pendingStatus = status;
    AlertDialogHelper.showAlertDialog(
      '',
      confirmMessage,
      'yes'.tr,
      'no'.tr,
      '',
      true,
      false,
      this,
      dialogIdentifier,
    );
  }

  void _onRequestBulkActionTap({
    required int status,
    required String confirmMessage,
    required String dialogIdentifier,
  }) {
    final selected = productsList.where((e) => e.isCheck == true).toList();
    if (selected.isEmpty) {
      AppUtils.showToastMessage('msg_select_at_least_one_item'.tr);
      return;
    }
    _pendingStatus = status;
    AlertDialogHelper.showAlertDialog(
      '',
      confirmMessage,
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
    final selectedIds = (isRequestFlow.value
            ? productsList.where((e) => e.isCheck == true)
            : productsList)
        .where((e) => (e.productId ?? 0) > 0)
        .map((e) => e.productId!.toString())
        .toList();
    if (_orderId <= 0 || _pendingStatus <= 0 || selectedIds.isEmpty) {
      return;
    }
    isLoading.value = true;
    _api.updateHireOrderStatus(
      data: {
        'company_id': ApiConstants.companyId,
        'id': _orderId,
        'status': _pendingStatus,
        'product_ids': selectedIds.join(','),
        if (_shouldSendNeedService) 'need_service': needService.value,
      },
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          String message = responseModel.statusMessage ?? '';
          int statusForTab = _pendingStatus;
          final result = responseModel.result;
          if (result != null && result.isNotEmpty) {
            try {
              final deliver =
                  HireOrderUpdateStatusResponse.fromJson(jsonDecode(result));
              if (deliver.message != null && deliver.message!.isNotEmpty) {
                message = deliver.message!;
              }
              if (deliver.info?.status != null) {
                statusForTab = deliver.info!.status!;
              }
            } catch (_) {
              try {
                final baseResponse = BaseResponse.fromJson(jsonDecode(result));
                if (baseResponse.Message != null &&
                    baseResponse.Message!.isNotEmpty) {
                  message = baseResponse.Message!;
                }
              } catch (_) {}
            }
          }
          AppUtils.showApiResponseMessage(message);
          Get.back(result: {
            AppConstants.intentKey.status: statusForTab,
            AppConstants.intentKey.result: true,
          });
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
    _shouldSendNeedService = false;
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == _dialogApprove ||
        dialogIdentifier == _dialogCancel ||
        dialogIdentifier == _dialogReturn ||
        dialogIdentifier == _dialogAvailable ||
        dialogIdentifier == _dialogDamaged) {
      Get.back();
      _updateHireOrderStatusApi();
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == _dialogApprove ||
        dialogIdentifier == _dialogCancel ||
        dialogIdentifier == _dialogReturn ||
        dialogIdentifier == _dialogAvailable ||
        dialogIdentifier == _dialogDamaged) {
      Get.back();
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}
}
