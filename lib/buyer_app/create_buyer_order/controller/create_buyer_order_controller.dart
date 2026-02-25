import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_repository.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateBuyerOrderController extends GetxController
    implements DialogButtonClickListener {
  final _api = CreateBuyerOrderRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  double cardRadius = 12;
  int selectedIndex = 0;
  final buyerOrdersList = <OrderInfo>[].obs;
  List<OrderInfo> tempBuyerOrderList = [];
  final searchController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    tempBuyerOrderList.clear();
    tempBuyerOrderList.addAll([
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
    buyerOrdersList.value = tempBuyerOrderList;
  }

  void increaseQty(int index) {
    if (buyerOrdersList[index].qty < buyerOrdersList[index].availableQty) {
      buyerOrdersList[index].qty++;
      buyerOrdersList.refresh();
    }
  }

  void decreaseQty(int index) {
    if (buyerOrdersList[index].qty > 1) {
      buyerOrdersList[index].qty--;
      buyerOrdersList.refresh();
    }
  }

  void removeItem(int index) {
    selectedIndex = index;
    showDeleteDialog();
  }

  void onItemClick(int index) {}

  double get grandTotal =>
      buyerOrdersList.fold(0, (sum, item) => sum + item.totalPrice);

  void setQty(int index, int qty) {
    final item = buyerOrdersList[index];

    int finalQty;

    if (qty < 1) {
      finalQty = 0;
    } else if (qty > item.availableQty) {
      finalQty = item.availableQty;
    } else {
      finalQty = qty;
    }

    item.qty = finalQty;
    buyerOrdersList.refresh();
  }

  Future<void> searchItem(String value) async {
    List<OrderInfo> results = [];
    if (value.isEmpty) {
      results = tempBuyerOrderList;
    } else {
      results = tempBuyerOrderList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    buyerOrdersList.value = results;
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
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
      buyerOrdersList.removeAt(selectedIndex);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}
}
