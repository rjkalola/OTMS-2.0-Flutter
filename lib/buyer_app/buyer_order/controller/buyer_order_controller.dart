import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/purchasing/controller/purchasing_repository.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BuyerOrderController extends GetxController
    implements DialogButtonClickListener {
  final _api = BuyerOrderRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  double cardRadius = 12;
  int selectedIndex = 0;
  RxInt requestCount = 0.obs, proceedCount = 0.obs, deliveredCount = 0.obs;
  final searchAddressController = TextEditingController().obs;
  final ordersList = <OrderInfo>[].obs;
  List<OrderInfo> tempList = [];
  final selectedTab = OrderTabType.request.obs;

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
    loadOrders();
  }

  void loadOrders() {
    tempList.clear();
    tempList.addAll([
      OrderInfo(
        id: 1,
        name: "ElectriQ 60cm 4 Zone Induction Hob",
        sku: "DCK1234",
        image: "https://via.placeholder.com/150",
        availableQty: 1000,
        projectName: "DCK Northumberland",
        userName: "Alex Novok +2",
        price: 2500.00,
        qty: 5,
      ),
      OrderInfo(
        id: 2,
        name: "Twfydord Alcona Close Coupled Toilet Pan",
        sku: "DCK1234",
        image: "https://samplelib.com/lib/preview/png/sample-boat-400x300.png",
        availableQty: 5,
        projectName: "DCK Northumberland",
        userName: "Alex Novok +2",
        price: 43.21,
        qty: 1,
      ),
    ]);
    ordersList.value = tempList;
  }

  void increaseQty(int index) {
    if (ordersList[index].qty < ordersList[index].availableQty) {
      ordersList[index].qty++;
      ordersList.refresh();
    }
  }

  void decreaseQty(int index) {
    if (ordersList[index].qty > 1) {
      ordersList[index].qty--;
      ordersList.refresh();
    }
  }

  void removeItem(int index) {
    selectedIndex = index;
    showDeleteDialog();
  }

  void onItemClick(int index) {}

  double get grandTotal =>
      ordersList.fold(0, (sum, item) => sum + item.totalPrice);

  void setQty(int index, int qty) {
    final item = ordersList[index];

    int finalQty;

    if (qty < 1) {
      finalQty = 1;
    } else if (qty > item.availableQty) {
      finalQty = item.availableQty;
    } else {
      finalQty = qty;
    }

    item.qty = finalQty;
    ordersList.refresh();
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
      ordersList.removeAt(selectedIndex);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  Future<void> searchItem(String value) async {
    print(value);
    List<OrderInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    ordersList.value = results;
  }

  void clearSearch() {
    searchAddressController.value.clear();
    searchItem("");
  }

  @override
  void onClose() {
    for (final node in qtyFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
