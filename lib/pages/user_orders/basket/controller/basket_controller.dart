import 'dart:convert';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/project/address_list/controller/address_list_repository.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/address_list/model/address_list_response.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/view/active_project_dialog.dart';
import 'package:belcka/pages/user_orders/basket/controller/basket_repository.dart';
import 'package:belcka/pages/user_orders/basket/model/product_cart_list_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/widgets/select_address_dialog.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BasketController extends GetxController implements SelectItemListener{
  RxBool isDeliverySelected = true.obs;
  final _api = BasketRepository();
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
  final addressList = <AddressInfo>[].obs;
  RxInt activeProjectId = 0.obs;
  RxString activeProjectTitle = "".obs;

  RxInt selectedAddressId = 0.obs;
  RxString selectedAddressTitle = "".obs;

  RxString selectedDeliveryTime = "".obs;
  RxDouble totalAmount = 0.0.obs;

  final List<ModuleInfo> listDeliveryTime = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    setupDeliveryTimeData();
    getProjectListApi();
  }
  void setupDeliveryTimeData(){
    listDeliveryTime.insert(0, ModuleInfo(id: 1,name: "Today"));
    listDeliveryTime.insert(1, ModuleInfo(id: 2,name: "Tomorrow"));
    listDeliveryTime.insert(2, ModuleInfo(id: 3,name: "In week"));
    listDeliveryTime.insert(3, ModuleInfo(id: 4,name: "In 10 days"));
    listDeliveryTime.insert(4, ModuleInfo(id: 5,name: "In 15 days"));
    selectedDeliveryTime.value = listDeliveryTime[0].name ?? "";
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
            getAddressListApi(0);
          }
          else{
            isMainViewVisible.value = true;
            tempList.clear();
            addressList.clear();
            addressList.refresh();
          }

          fetchCartList();

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

  void getAddressListApi(int status) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["project_id"] = activeProjectId.value;
    map["status"] = status;
    AddressListRepository().getAddressList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressListResponse response =
          AddressListResponse.fromJson(jsonDecode(responseModel.result!));
          addressList.clear();
          addressList.value = response.info ?? [];
          addressList.refresh();
          if (addressList.isNotEmpty) {
            selectedAddressId.value = addressList[0].id ?? 0;
            selectedAddressTitle.value = addressList[0].name ?? "";
          }
          else{
            selectedAddressId.value = 0;
            selectedAddressTitle.value = "";
          }
        }
        else{
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
  void activeProjectAPI(int id, String title) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = id;

    _api.activeProject(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          activeProjectId.value = id;
          activeProjectTitle.value = title;
          getAddressListApi(0);
        }
        else{
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
  void fetchCartList() {
    //isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getCartListAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProductCartListResponse response =
          ProductCartListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          cartList.value = tempList;
          cartList.refresh();
          isMainViewVisible.value = true;
          isLoading.value = false;
          calculateTotal();
        }
        else{
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
  void toggleRemoveCart(int index) {
    final product = cartList[index];
    Map<String, dynamic> map = {};
    map["id"] = product.id;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchCartList();
        }
        else{
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
    isLoading.value = true;
    final body = createOrderRequest(
      companyId: ApiConstants.companyId,
      projectId: activeProjectId.value,
        addressId: selectedAddressId.value,
        deliverOn: selectedDeliveryTime.value
    );
    print(body);
    _api.createEmployeeOrderAPI(
      data: body,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchCartList();
        }
        else{
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

  Map<String, dynamic> createOrderRequest({
    required int companyId,
    required int projectId,
    required int addressId,
    required String deliverOn,
  }) {
    return {
      "company_id": companyId,
      "project_id": projectId,
      if (addressId > 0)
      "address_id":addressId,
      "deliver_on":deliverOn,
      "product_data": cartList.map((item) {
        return {
          "product_id": item.productId,
          "qty": item.cartQty ?? 0,
          "price": item.price,
        };
      }).toList(),
    };
  }

  void increaseQty(int index) {
    final product = cartList[index];
    int qty = product.qty ?? 0;
    int userQty = (product.cartQty ?? 0) + 1;
    product.cartQty = userQty;
    calculateTotal();
  }
  void decreaseQty(int index) {
    final product = cartList[index];
    int qty = product.qty ?? 0;
    int userQty = product.cartQty ?? 0;
    if (userQty == 1) return;
    product.cartQty = userQty - 1;
    calculateTotal();
  }
  String calculateTotal() {
    totalAmount.value = 0.0;
    for (var item in cartList) {
      double price = double.tryParse(item.price ?? "") ?? 0.00;
      int qty = item.cartQty ?? 0;
      totalAmount.value += price * qty;
    }
    return totalAmount.value.toStringAsFixed(2);
  }
  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  void showActiveProjectDialog() {
    if (projectsList.isNotEmpty) {
      Get.bottomSheet(
          ActiveProjectDialog(
            dialogType: AppConstants.dialogIdentifier.selectProject,
            list: projectsList,
            selectedProjectId: activeProjectId.value,
            listener: this,
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true);
    } else {
      AppUtils.showToastMessage('empty_project_list'.tr);
    }
  }

  void showAddressListDialog(String dialogType, String title,
      List<AddressInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        SelectAddressDialog(
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
  void showAddressList() {
    if (addressList.isNotEmpty){
      showAddressListDialog(AppConstants.dialogIdentifier.selectAddress,
          'select_address'.tr, addressList, this);
    }
    else{
      AppUtils.showToastMessage('empty_address_list'.tr);
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
  void showDeliveryTimeList() {
    showDeliveryTimeListDialog(AppConstants.dialogIdentifier.selectCategory,
        'select_delivery_time'.tr, listDeliveryTime, this);
  }
  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
      selectedAddressId.value = 0;
      selectedAddressTitle.value = "";
      activeProjectAPI(id, name);
    }
    else if (action == AppConstants.dialogIdentifier.selectCategory) {
      selectedDeliveryTime.value = name;
    }
    else if (action == AppConstants.dialogIdentifier.selectAddress) {
      selectedAddressId.value = id;
      selectedAddressTitle.value = name;
    }
    print(name);
  }
}