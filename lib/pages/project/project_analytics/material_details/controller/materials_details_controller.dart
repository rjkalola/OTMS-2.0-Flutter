import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
import 'package:belcka/pages/project/project_analytics/material_details/model/material_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialsDetailsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isDataUpdated = false.obs;

  final orders = [
    MaterialOrder(orderId: 'C-123123A', status: OrderStatus.completed, amount: 3200, date: DateTime(2025, 9, 3), address: '34 Acacia', user: 'Roland Butkevic', itemsDelivered: 3, itemsTotal: 3),
    MaterialOrder(orderId: 'R-57684', status: OrderStatus.returned, amount: 200, date: DateTime(2025, 9, 3), address: '30 Northchurch', user: 'Vladimir Bozianu', itemsDelivered: 5, itemsTotal: 5),
    MaterialOrder(orderId: 'K-45672', status: OrderStatus.cancelled, amount: 3200, date: DateTime(2025, 9, 3), address: '7 Haliwell House', user: 'Josh Neman', itemsDelivered: 3, itemsTotal: 3),
    MaterialOrder(orderId: 'C-543123A', status: OrderStatus.completed, amount: 3200, date: DateTime(2025, 9, 3), address: '34 Acacia', user: 'Roland Butkevic', itemsDelivered: 3, itemsTotal: 3),
    MaterialOrder(orderId: 'P-88812', status: OrderStatus.pending, amount: 1500, date: DateTime(2025, 10, 15), address: '12 Birch Lane', user: 'Sam O\'Brien', itemsDelivered: 0, itemsTotal: 4),
    MaterialOrder(orderId: 'C-991001', status: OrderStatus.completed, amount: 4750, date: DateTime(2025, 8, 20), address: '5 Maple Court', user: 'Roland Butkevic', itemsDelivered: 6, itemsTotal: 6),
  ];

  FilterPeriod filter = FilterPeriod.all;
  bool searchOpen = false;
  String searchQuery = '';
  final searchCtrl = TextEditingController();
  late AnimationController ctrl;
  late Animation<double> fadeAnim;

  final double totalBudget = 220500.42;
  final double spent = 220500.42;
  final double overspending = 20500.42;

  // Summary counts
  int get completedCount => filtered.where((o) => o.status == OrderStatus.completed).length;
  int get returnedCount => filtered.where((o) => o.status == OrderStatus.returned).length;
  int get cancelledCount => filtered.where((o) => o.status == OrderStatus.cancelled).length;
  double get filteredTotal => filtered.fold(0.0, (s, o) => s + o.amount);

  List<MaterialOrder> get filtered {
    var list = orders;
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((o) =>
      o.orderId.toLowerCase().contains(q) ||
          o.address.toLowerCase().contains(q) ||
          o.user.toLowerCase().contains(q) || statusLabel(o.status).toLowerCase().contains(q)
      ).toList();
    }
    return list;
  }

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void dispose() {

    super.dispose();
  }
  String statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.completed: return 'Completed';
      case OrderStatus.returned: return 'Returned';
      case OrderStatus.cancelled: return 'Cancelled';
      case OrderStatus.pending: return 'Pending';
    }
  }
}
