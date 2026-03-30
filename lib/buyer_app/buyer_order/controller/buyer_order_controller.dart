import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_order_invoice_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_orders_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_product_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class BuyerOrderController extends GetxController
    implements DialogButtonClickListener {
  final _api = BuyerOrderRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isSingleFilter = false.obs;
  RxString startDate = "".obs,
      endDate = "".obs,
      displayStartDate = "".obs,
      displayEndDate = "".obs;
  RxInt requestCount = 0.obs,
      upcomingCount = 0.obs,
      proceedCount = 0.obs,
      deliveredCount = 0.obs,
      cancelledCount = 0.obs,
      selectedDateFilterIndex = (2).obs;
  double cardRadius = 12;
  int selectedIndex = 0;
  String title = "";
  final searchController = TextEditingController().obs;
  final requestOrdersList = <ProductInfo>[].obs;
  final ordersList = <OrderInfo>[].obs;
  List<ProductInfo> tempRequestOrderList = [];
  List<OrderInfo> tempOrdersList = [];
  final selectedTab = OrderTabType.request.obs;
  final filterItemsList = <ModuleInfo>[].obs;
  Map<String, String> appliedFilters = {};

  final ScrollController requestScrollController = ScrollController();
  final ScrollController ordersScrollController = ScrollController();

  final List<FocusNode> qtyFocusNodes = [];

  FocusNode getQtyFocusNode(int index) {
    if (qtyFocusNodes.length <= index) {
      qtyFocusNodes.add(FocusNode());
    }
    return qtyFocusNodes[index];
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? "";
      if (selectedTabType == AppConstants.type.request) {
        selectedTab.value = OrderTabType.request;
      } else if (selectedTabType == AppConstants.type.upComing) {
        selectedTab.value = OrderTabType.upcoming;
      } else if (selectedTabType == AppConstants.type.proceed) {
        selectedTab.value = OrderTabType.proceed;
      } else if (selectedTabType == AppConstants.type.delivered) {
        selectedTab.value = OrderTabType.delivered;
      } else if (selectedTabType == AppConstants.type.cancelled) {
        selectedTab.value = OrderTabType.cancelled;
      }
      selectedDateFilterIndex.value =
          arguments[AppConstants.intentKey.index] ?? 2;
      startDate.value = arguments[AppConstants.intentKey.startDate] ?? "";
      endDate.value = arguments[AppConstants.intentKey.endDate] ?? "";
      displayStartDate.value = startDate.value;
      displayEndDate.value = endDate.value;

      String filterType = arguments[AppConstants.intentKey.filterType] ?? "";
      int recordId = arguments[AppConstants.intentKey.recordId] ?? 0;
      title = arguments[AppConstants.intentKey.title] ?? "";
      if (!StringHelper.isEmptyString(filterType)) {
        isSingleFilter.value = true;
        setSingleFilter(filterType, recordId.toString());
      }
    }
    loadData();
  }

  void loadData() {
    clearSearch();
    isSearchEnable.value = false;
    if (selectedTab.value == OrderTabType.request) {
      buyerProductsListApi();
    } else if (selectedTab.value == OrderTabType.upcoming) {
      buyerOrdersListApi(AppConstants.orderStatus.received.toString());
    } else if (selectedTab.value == OrderTabType.proceed) {
      buyerOrdersListApi(
          "${AppConstants.orderStatus.processing.toString()},${AppConstants.orderStatus.partialReceived.toString()}");
    } else if (selectedTab.value == OrderTabType.delivered) {
      buyerOrdersListApi(AppConstants.orderStatus.inStock.toString());
    }else if (selectedTab.value == OrderTabType.cancelled) {
      buyerOrdersListApi(AppConstants.orderStatus.cancelled.toString());
    }
  }

  void buyerProductsListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    for (var entry in appliedFilters.entries) {
      String key = entry.key ?? "";
      String value = entry.value ?? "";
      map[key] = value;
    }
    _api.buyerProductsList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerProductListResponse response = BuyerProductListResponse.fromJson(
              jsonDecode(responseModel.result!));

          for (ProductInfo info in response.info ?? []) {
            info.cartQty =
                (info.totalQty ?? 0) < 0 ? 0 : (info.totalQty ?? 0).toDouble();
          }

          tempRequestOrderList.clear();
          tempRequestOrderList.addAll(response.info!);
          requestOrdersList.value = tempRequestOrderList;
          requestCount.value = tempRequestOrderList.length;
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

  void updateTabCount({
    int? upcoming,
    int? processing,
    int? partialDelivered,
    int? delivered,
    int? cancelled,
  }) {
    upcomingCount.value = upcoming ?? 0;
    proceedCount.value = (processing ?? 0) + (partialDelivered ?? 0);
    deliveredCount.value = delivered ?? 0;
    cancelledCount.value = cancelled ?? 0;
  }

  void buyerOrdersListApi(String status) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate.value;
    map["end_date"] = endDate.value;
    map["status"] = status;
    _api.buyerOrdersList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrdersListResponse response = BuyerOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));

          updateTabCount(
            upcoming: response.upcoming,
            processing: response.processing,
            partialDelivered: response.partialDelivered,
            delivered: response.delivered,
            cancelled: response.cancelled,
          );

          tempOrdersList.clear();
          tempOrdersList.addAll(response.info ?? []);
          ordersList.value = List<OrderInfo>.from(tempOrdersList);
          ordersList.refresh();
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          //   if (ordersScrollController.hasClients) {
          //     ordersScrollController.jumpTo(0);
          //   }
          // });

          startDate.value = response.startDate ?? "";
          endDate.value = response.endDate ?? "";

          displayStartDate.value = response.startDate ?? "";
          displayEndDate.value = response.endDate ?? "";
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

  void buyerOrderInvoiceApi(int id) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = id;
    _api.buyerOrderInvoice(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) async {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrderInvoiceResponse response =
              BuyerOrderInvoiceResponse.fromJson(
                  jsonDecode(responseModel.result!));
          String fileUrl = response.invoice ?? "";
          await ImageUtils.openAttachment(
              Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
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

  void increaseQty(int index) {
    // if (requestOrdersList[index].cartQty < requestOrdersList[index].availableQty) {
    requestOrdersList[index].cartQty =
        (requestOrdersList[index].cartQty ?? 0) + 1;
    requestOrdersList.refresh();
    // }
  }

  void decreaseQty(int index) {
    if ((requestOrdersList[index].cartQty ?? 0) > 0) {
      print("requestOrdersList[index].cartQty:" +
          (requestOrdersList[index].cartQty).toString());

      requestOrdersList[index].cartQty =
          (requestOrdersList[index].cartQty ?? 0) - 1;
      // requestOrdersList[index].cartQty--;

      print("requestOrdersList[index].cartQty::" +
          (requestOrdersList[index].cartQty).toString());

      requestOrdersList.refresh();
    }
  }

  void removeItem(int index) {
    selectedIndex = index;
    showDeleteDialog();
  }

  void onItemClick(int index) {
    if (selectedTab.value == OrderTabType.request) {
      return;
    }
    if (selectedTab.value == OrderTabType.upcoming ||
        selectedTab.value == OrderTabType.proceed ||
        selectedTab.value == OrderTabType.delivered ||
        selectedTab.value == OrderTabType.cancelled) {
      var arguments = {
        AppConstants.intentKey.orderId: ordersList[index].id ?? 0,
      };
      moveToScreen(
          appRout: AppRoutes.buyerOrderDetailScreen, arguments: arguments);
    }
  }

  // double get grandTotal =>
  //     requestOrdersList.fold(0, (sum, item) => sum + item.totalPrice);

  void setQty(int index, int qty) {
    // final item = requestOrdersList[index];
    //
    // int finalQty;
    //
    // if (qty < 1) {
    //   finalQty = 0;
    // } else if (qty > (item.qty ?? 0)) {
    //   finalQty = item.qty ?? 0;
    // } else {
    //   finalQty = qty;
    // }
    //
    // item.cartQty = finalQty;
    // requestOrdersList.refresh();
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
      requestOrdersList.removeAt(selectedIndex);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  Future<void> searchItem(String value) async {
    print(value);
    if (selectedTab.value == OrderTabType.request) {
      List<ProductInfo> results = [];
      if (value.isEmpty) {
        results = tempRequestOrderList;
      } else {
        String query = value.toLowerCase();
        results = tempRequestOrderList.where((element) {
          return (!StringHelper.isEmptyString(element.shortName) &&
                  element.shortName!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(element.uuid) &&
                  element.uuid!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(element.storeName) &&
                  element.storeName!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(element.supplierName) &&
                  element.supplierName!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(element.productCategories) &&
                  element.productCategories!.toLowerCase().contains(query)) ||
              (!StringHelper.isEmptyString(element.projectName) &&
                  element.projectName!.toLowerCase().contains(query));
        }).toList();
      }
      requestOrdersList.value = results;
    } else if (selectedTab.value == OrderTabType.upcoming ||
        selectedTab.value == OrderTabType.proceed ||
        selectedTab.value == OrderTabType.delivered) {
      ordersList.value = _filterOrderInfoList(tempOrdersList, value);
    }
  }

  List<OrderInfo> _filterOrderInfoList(List<OrderInfo> source, String value) {
    if (value.isEmpty) {
      return List<OrderInfo>.from(source);
    }
    final query = value.toLowerCase();
    return source
        .where((element) =>
            (!StringHelper.isEmptyString(element.storeName) &&
                element.storeName!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.supplierName) &&
                element.supplierName!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.orderId) &&
                element.orderId!.toLowerCase().contains(query)) ||
            (!StringHelper.isEmptyString(element.orderNumber) &&
                element.orderNumber!.toLowerCase().contains(query)))
        .toList();
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
  }

  Future<void> moveToCreateOrderScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result) {
      selectedTab.value = OrderTabType.upcoming;
      loadData();
    }
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    // if (result != null && result) {
    //   selectedTab.value = OrderTabType.delivered;
    //   loadData();
    // }

    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        int status = arguments[AppConstants.intentKey.status] ?? 0;
        bool result = arguments[AppConstants.intentKey.result] ?? false;
        if (result) {
          if (status == AppConstants.orderStatus.issued) {
            selectedTab.value = OrderTabType.upcoming;
          } else if (status == AppConstants.orderStatus.partialReceived ||
              status == AppConstants.orderStatus.processing) {
            selectedTab.value = OrderTabType.proceed;
          } else if (status == AppConstants.orderStatus.received) {
            selectedTab.value = OrderTabType.delivered;
          } else {
            selectedTab.value = OrderTabType.proceed;
          }
        }
      }
      loadData();
    }
  }

  Future<void> moveToFilterScreen() async {
    var arguments = {
      AppConstants.intentKey.filterType:
          AppConstants.filterType.buyerOrderProductsFilter,
      AppConstants.intentKey.filterData: appliedFilters,
    };
    var result =
        await Get.toNamed(AppRoutes.filterScreen, arguments: arguments);
    if (result != null) {
      appliedFilters = result;
      setFilterItems();
      loadData();
    }
  }

  void setSingleFilter(String key, String value) {
    appliedFilters = {};
    appliedFilters[key] = value;
    setFilterItems();
  }

  void setFilterItems() {
    filterItemsList.clear();
    for (var entry in appliedFilters.entries) {
      String key = entry.key ?? "";
      String value = entry.value ?? "";
      ModuleInfo info = ModuleInfo();
      if (isSingleFilter.value && !StringHelper.isEmptyString(title)) {
        info.name = "${StringHelper.capitalizeFirstLetter(key)}: $title";
      } else {
        info.name = StringHelper.capitalizeFirstLetter(key);
      }

      info.value = value;
      List<String> list = value.split(",");
      info.count = !isSingleFilter.value ? list.length : 0;
      filterItemsList.add(info);
      print("--------------");
      print("${entry.key}: ${entry.value}");
    }
    if (filterItemsList.isNotEmpty && !isSingleFilter.value) {
      filterItemsList.insert(
          0, ModuleInfo(name: 'reset'.tr, action: AppConstants.action.reset));
    }
    filterItemsList.refresh();
  }

  void clearFilter() {
    appliedFilters = {};
    setFilterItems();
    loadData();
  }

  @override
  void onClose() {
    for (final node in qtyFocusNodes) {
      node.dispose();
    }
    requestScrollController.dispose();
    ordersScrollController.dispose();
    super.onClose();
  }
}
