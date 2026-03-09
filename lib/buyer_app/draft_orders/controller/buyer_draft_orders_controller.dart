import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_orders_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/draft_orders/controller/buyer_draft_orders_repository.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/AlertDialogHelper.dart';
import '../../../utils/app_constants.dart';

class BuyerDraftOrdersController extends GetxController
    implements DialogButtonClickListener {
  final _api = BuyerDraftOrdersRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  final ordersList = <OrderInfo>[].obs;
  List<OrderInfo> tempOrderList = [];
  final searchController = TextEditingController().obs;
  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    buyerOrdersListApi(true);
  }

  void buyerOrdersListApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["is_draft"] = true;
    BuyerOrderRepository().buyerOrdersList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrdersListResponse response = BuyerOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempOrderList.clear();
          tempOrderList.addAll(response.info ?? []);
          ordersList.value = tempOrderList;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void deleteOrderApi(int id) {
    isLoading.value = false;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["id"] = id;
    _api.buyerOrderDelete(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showToastMessage(response.Message ?? "");
          // Get.back(result: true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void onItemClick(int index) {
    var arguments = {
      AppConstants.intentKey.orderId: ordersList[index].id ?? 0,
    };
    moveToScreen(
        appRout: AppRoutes.createBuyerOrderScreen, arguments: arguments);
  }

  void onDeleteClick(int index) {
    selectedIndex = index;
    showDeleteDialog();
  }

  void showDeleteDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      Get.back();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      Get.back();
      int id = ordersList[selectedIndex].id ?? 0;
      ordersList.removeAt(selectedIndex);
      ordersList.refresh();
      deleteOrderApi(id);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result) {
      buyerOrdersListApi(true);
    }
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<OrderInfo> results = [];
    if (value.isEmpty) {
      results = tempOrderList;
    } else {
      results = tempOrderList
          .where((element) =>
              (!StringHelper.isEmptyString(element.supplierName) &&
                  element.supplierName!
                      .toLowerCase()
                      .contains(value.toLowerCase())))
          .toList();
    }
    ordersList.value = results;
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
    isSearchEnable.value = false;
  }

  void onBackPress() {
    Get.back(result: true);
  }
}
