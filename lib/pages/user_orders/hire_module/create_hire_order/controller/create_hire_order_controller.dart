import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/project/address_list/controller/address_list_repository.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/address_list/model/address_list_response.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/user_orders/hire_module/create_hire_order/controller/create_hire_order_repository.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateHireOrderController  extends GetxController
    implements SelectItemListener, SelectDateListener {
  RxBool isDeliverySelected = true.obs;
  final _api = CreateHireOrderRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final cartList = <ProductInfo>[].obs;
  List<ProductInfo> tempList = [];
  final Map<int, int> currentImageIndex = {};
  bool isDataUpdated = false;

  final projectsList = <ProjectInfo>[].obs;
  final addressList = <ModuleInfo>[].obs;

  RxInt activeProjectId = 0.obs;
  RxString activeProjectTitle = "".obs;

  RxInt selectedAddressId = 0.obs;
  RxString selectedAddressTitle = "".obs;

  final hireFromDate = Rxn<DateTime>();
  final hireToDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      cartList.value = arguments[AppConstants.intentKey.productsData] ?? [];
      print("cartList size:"+cartList.length.toString());
    }
    getProjectListApi();
  }

  void getProjectListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProjectListResponse response =
              ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          projectsList.clear();
          projectsList.addAll(response.info!);

          activeProjectId.value = response.id ?? 0;
          activeProjectTitle.value = response.name ?? "";

          if (activeProjectId.value != 0) {
            getAddressListApi(true);
          } else {
            isMainViewVisible.value = true;
            addressList.clear();
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void getAddressListApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["project_id"] = activeProjectId.value;
    map["status"] = 0;
    AddressListRepository().getAddressList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressListResponse response =
              AddressListResponse.fromJson(jsonDecode(responseModel.result!));
          addressList.clear();
          for (AddressInfo addressInfo in response.info!) {
            addressList
                .add(ModuleInfo(id: addressInfo.id, name: addressInfo.name));
          }
          if (addressList.isNotEmpty) {
            selectedAddressId.value = addressList[0].id ?? 0;
            selectedAddressTitle.value = addressList[0].name ?? "";
          } else {
            selectedAddressId.value = 0;
            selectedAddressTitle.value = "";
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void toggleCreateOrder() {
    if (hireFromDate.value == null) {
      AppUtils.showToastMessage('please_select_hire_from_first'.tr);
      return;
    }

    if (hireToDate.value == null) {
      AppUtils.showToastMessage('please_select_hire_to_date'.tr);
      return;
    }

    final fromDay = DateTime(
      hireFromDate.value!.year,
      hireFromDate.value!.month,
      hireFromDate.value!.day,
    );
    final toDay = DateTime(
      hireToDate.value!.year,
      hireToDate.value!.month,
      hireToDate.value!.day,
    );
    if (toDay.isBefore(fromDay)) {
      AppUtils.showToastMessage('hire_to_must_be_on_or_after_from'.tr);
      return;
    }

    final productIds = cartList
        .map((item) => item.productId ?? 0)
        .where((id) => id > 0)
        .toList();
    if (productIds.isEmpty) {
      AppUtils.showToastMessage('msg_add_at_least_one_qty'.tr);
      return;
    }

    isLoading.value = true;
    final body = createOrderRequest(
      companyId: ApiConstants.companyId,
      projectId: activeProjectId.value,
      addressId: selectedAddressId.value,
      productIds: productIds,
    );
    _api.createHireOrderAPI(
      data: body,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          isDataUpdated = true;
          Get.back(result: true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Map<String, dynamic> createOrderRequest({
    required int companyId,
    required int projectId,
    required int addressId,
    required List<int> productIds,
  }) {
    return {
      "company_id": companyId,
      if (projectId > 0) "project_id": projectId,
      if (addressId > 0) "address_id": addressId,
      if (hireFromDate.value != null)
        "from_date":
            DateUtil.dateToString(hireFromDate.value!, DateUtil.DD_MM_YYYY_SLASH),
      if (hireToDate.value != null)
        "to_date":
            DateUtil.dateToString(hireToDate.value!, DateUtil.DD_MM_YYYY_SLASH),
      "product_ids": productIds.join(","),
    };
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated = result;
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  void showProjectList() {
    if (projectsList.isNotEmpty) {
      List<ModuleInfo> list = [];
      for (ProjectInfo projectInfo in projectsList) {
        list.add(ModuleInfo(id: projectInfo.id, name: projectInfo.name));
      }
      showDropDownDialog(AppConstants.dialogIdentifier.selectProject,
          'select_project'.tr, list, this);
    } else {
      AppUtils.showToastMessage('empty_project_list'.tr);
    }
  }

  void showAddressList() {
    if (addressList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectAddress,
          'select_address'.tr, addressList, this);
    } else {
      AppUtils.showToastMessage('empty_address_list'.tr);
    }
  }

  void showHireFromDatePicker() {
    final now = DateTime.now();
    final first = DateTime(now.year - 1);
    final last = DateTime(now.year + 5);
    showDatePickerDialog(
      AppConstants.dialogIdentifier.hireFromDate,
      hireFromDate.value,
      DateTime.now(),
      DateTime(2050),
    );
  }

  void showHireToDatePicker() {
    if (hireFromDate.value == null) {
      AppUtils.showToastMessage('please_select_hire_from_first'.tr);
      return;
    }

    final fromDay = DateTime(
      hireFromDate.value!.year,
      hireFromDate.value!.month,
      hireFromDate.value!.day,
    );
    final last = DateTime(2050);

    DateTime? initial = hireToDate.value;
    if (initial != null) {
      final initialDay = DateTime(initial.year, initial.month, initial.day);
      if (initialDay.isBefore(fromDay)) {
        initial = fromDay;
      }
    } else {
      initial = fromDay;
    }

    showDatePickerDialog(
      AppConstants.dialogIdentifier.hireToDate,
      initial,
      fromDay,
      last,
    );
  }

  void showDatePickerDialog(String dialogIdentifier, DateTime? date,
      DateTime firstDate, DateTime lastDate) {
    DateUtil.showDatePickerDialog(
      initialDate: date,
      firstDate: firstDate,
      lastDate: lastDate,
      dialogIdentifier: dialogIdentifier,
      selectDateListener: this,
    );
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.hireFromDate) {
      hireFromDate.value = date;
      if (hireToDate.value != null && hireToDate.value!.isBefore(date)) {
        hireToDate.value = null;
      }
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.hireToDate) {
      if (hireFromDate.value == null) {
        AppUtils.showToastMessage('please_select_hire_from_first'.tr);
        return;
      }
      final fromDay = DateTime(
        hireFromDate.value!.year,
        hireFromDate.value!.month,
        hireFromDate.value!.day,
      );
      final pickedDay = DateTime(date.year, date.month, date.day);
      if (pickedDay.isBefore(fromDay)) {
        AppUtils.showToastMessage('hire_to_must_be_on_or_after_from'.tr);
        return;
      }
      hireToDate.value = date;
    }
  }

  void showDeliveryTimeListDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: false,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
      activeProjectId.value = id;
      activeProjectTitle.value = name;
      print("id:${id} & name:${name}");
      selectedAddressId.value = 0;
      selectedAddressTitle.value = "";
      getAddressListApi(true);
    } else if (action == AppConstants.dialogIdentifier.selectAddress) {
      selectedAddressId.value = id;
      selectedAddressTitle.value = name;
      print("id:${id} & name:${name}");
    }
    print(name);
  }
}
