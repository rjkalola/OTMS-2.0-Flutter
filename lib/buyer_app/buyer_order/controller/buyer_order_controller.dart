import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/purchasing/controller/purchasing_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BuyerOrderController extends GetxController {
  final _api = PurchasingRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  double cardRadius = 12;
  RxString selectedStatusFilter = "request".obs;
  RxInt requestCount = 0.obs, proceedCount = 0.obs, deliveredCount = 0.obs;
  final searchAddressController = TextEditingController().obs;
  final ordersList = <OrderInfo>[].obs;

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
    ordersList.assignAll([
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
  }

  /// QUANTITY ACTIONS
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
    ordersList.removeAt(index);
  }

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

  @override
  void onClose() {
    for (final node in qtyFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
