import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_repository.dart';
import 'package:belcka/pages/permissions/user_list/model/user_list_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/storeman_app/edit_stock/controller/edit_stock_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditStockController extends GetxController implements SelectItemListener {
  static const int maxQty = 10000;

  final _api = EditStockRepository();

  late ProductInfo product;
  int storeId = 0;

  final referenceController = TextEditingController();
  final userController = TextEditingController().obs;
  final qtyController = TextEditingController();

  final isLoading = false.obs;
  final isReferenceMode = true.obs;
  final isPackMode = false.obs;
  final selectedUserId = 0.obs;

  final userList = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      product = arguments['product'] as ProductInfo;
      storeId = arguments['store_id'] ?? 0;
    }
    getUserListApi();
  }

  @override
  void onClose() {
    referenceController.dispose();
    userController.value.dispose();
    qtyController.dispose();
    super.onClose();
  }

  void toggleReferenceUserMode() {
    isReferenceMode.value = !isReferenceMode.value;
  }

  void togglePackMode() {
    if (product.isSubQty != true) return;
    isPackMode.value = !isPackMode.value;
  }

  bool get _isPackModeActive =>
      product.isSubQty == true && isPackMode.value;

  int get _isSubQtyValue => (product.isSubQty ?? false) ? 1 : 0;

  void onAddPressed() {
    final qty = _parseQty();
    if (qty == null) return;
    _submitEditStock(isAdd: true, qty: qty);
  }

  void onDeductPressed() {
    final qty = _parseQty();
    if (qty == null) return;
    _submitEditStock(isAdd: false, qty: qty);
  }

  int? _parseQty() {
    final qty = int.tryParse(qtyController.text.trim());
    if (qty == null || qty <= 0) {
      AppUtils.showToastMessage('enter_quantity'.tr);
      return null;
    }
    return qty > maxQty ? maxQty : qty;
  }

  void onQtyChanged(String value) {
    if (value.isEmpty) return;
    final qty = int.tryParse(value);
    if (qty != null && qty > maxQty) {
      final cappedText = maxQty.toString();
      qtyController.value = TextEditingValue(
        text: cappedText,
        selection: TextSelection.collapsed(offset: cappedText.length),
      );
    }
  }

  void _submitEditStock({required bool isAdd, required int qty}) {
    FocusManager.instance.primaryFocus?.unfocus();

    final source = _isPackModeActive ? 'packSizeQty' : 'subQty';
    var reference = '';
    int? userId;

    if (isReferenceMode.value) {
      reference = referenceController.text.trim();
    } else if (selectedUserId.value > 0) {
      userId = selectedUserId.value;
    }

    final map = <String, dynamic>{
      'is_sub_qty': _isSubQtyValue,
      'mode': 'edit',
      'price': product.price ?? '0.00',
      'product_id': product.id ?? product.productId ?? 0,
      'qty': isAdd ? qty : -qty,
      'reference': reference,
      'source': source,
      'store_id': storeId,
      'user_id': userId,
    };

    isLoading.value = true;
    _api.editStock(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          AppUtils.showToastMessage(_getResponseMessage(responseModel));
          Get.back(result: true);
        } else {
          AppUtils.showToastMessage(_getResponseMessage(responseModel));
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showToastMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  String _getResponseMessage(ResponseModel responseModel) {
    if (responseModel.result != null && responseModel.result!.isNotEmpty) {
      try {
        final json = jsonDecode(responseModel.result!) as Map<String, dynamic>;
        final message = json['message']?.toString();
        if (message != null && message.isNotEmpty) {
          return message;
        }
      } catch (_) {}
    }
    final statusMessage = responseModel.statusMessage?.trim() ?? '';
    if (statusMessage.isNotEmpty &&
        statusMessage.toLowerCase() != 'ok') {
      return statusMessage;
    }
    return 'stock_updated_successfully'.tr;
  }

  void getUserListApi() {
    final map = <String, dynamic>{};
    map['company_id'] = ApiConstants.companyId;

    UserListRepository().getUserList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response =
              UserListResponse.fromJson(jsonDecode(responseModel.result!));
          userList.clear();
          for (final data in response.info ?? []) {
            userList.add(ModuleInfo(id: data.id ?? 0, name: data.name ?? ''));
          }
        }
      },
      onError: (_) {},
    );
  }

  void showSelectUserDialog() {
    if (userList.isNotEmpty) {
      showDropDownDialog(
        AppConstants.action.selectUserDialog,
        'select_user'.tr,
        userList,
      );
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(
    String dialogType,
    String title,
    List<ModuleInfo> list,
  ) {
    Get.bottomSheet(
      DropDownListDialog(
        title: title,
        dialogType: dialogType,
        list: list,
        listener: this,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectUserDialog) {
      selectedUserId.value = id;
      userController.value.text = name;
      userController.refresh();
    }
  }
}
