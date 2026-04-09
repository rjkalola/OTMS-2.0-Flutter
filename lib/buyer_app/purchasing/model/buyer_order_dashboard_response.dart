import 'package:flutter/cupertino.dart';

class BuyerOrderDashboardResponse {
  bool? isSuccess;
  String? message;
  int? lowStock;
  int? outOfStock;
  int? damagedStock;
  int? uncompletedStock;
  int? products;
  int? projects;
  int? stores;
  int? categories;
  int? suppliers;
  int? requestedOrders;
  int? upcomingOrders;
  int? proceedOrders;
  int? receivedOrders;
  int? partiallyDeliveredOrders;
  int? cancelledOrders;
  int? hireAll;
  int? hireRequested;
  int? hireHired;
  int? hireServiced;
  int? hireDamaged;
  int? hireCanceled;
  int? hireAvailable;
  List<Inventory>? inventory;
  String? startDate, endDate;

  BuyerOrderDashboardResponse(
      {this.isSuccess,
      this.message,
      this.lowStock,
      this.outOfStock,
      this.damagedStock,
      this.uncompletedStock,
      this.products,
      this.projects,
      this.stores,
      this.categories,
      this.suppliers,
      this.requestedOrders,
      this.upcomingOrders,
      this.proceedOrders,
      this.receivedOrders,
      this.partiallyDeliveredOrders,
      this.cancelledOrders,
      this.hireAll,
      this.hireRequested,
      this.hireHired,
      this.hireServiced,
      this.hireDamaged,
      this.hireCanceled,
      this.hireAvailable,
      this.inventory,
      this.startDate,
      this.endDate});

  BuyerOrderDashboardResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    lowStock = json['low_stock'];
    outOfStock = json['out_of_stock'];
    damagedStock = json['damaged_stock'];
    uncompletedStock = json['uncompleted_stock'];
    products = json['products'];
    projects = json['projects'];
    stores = json['stores'];
    categories = json['categories'];
    suppliers = json['suppliers'];
    requestedOrders = json['requested_orders'];
    upcomingOrders = json['upcoming_orders'];
    proceedOrders = json['proceed_orders'];
    receivedOrders = json['received_orders'];
    partiallyDeliveredOrders = json['partially_delivered_orders'];
    cancelledOrders = json['cancelled_orders'];
    hireAll = json['hire_all'];
    hireRequested = json['hire_requested'];
    hireHired = json['hire_hired'];
    hireServiced = json['hire_serviced'];
    hireDamaged = json['hire_damaged'];
    hireCanceled = json['hire_canceled'];
    hireAvailable = json['hire_available'];
    if (json['inventory'] != null) {
      inventory = <Inventory>[];
      json['inventory'].forEach((v) {
        inventory!.add(new Inventory.fromJson(v));
      });
    }
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['low_stock'] = this.lowStock;
    data['out_of_stock'] = this.outOfStock;
    data['damaged_stock'] = this.damagedStock;
    data['uncompleted_stock'] = this.uncompletedStock;
    data['products'] = this.products;
    data['projects'] = this.projects;
    data['stores'] = this.stores;
    data['categories'] = this.categories;
    data['suppliers'] = this.suppliers;
    data['requested_orders'] = this.requestedOrders;
    data['upcoming_orders'] = this.upcomingOrders;
    data['proceed_orders'] = this.proceedOrders;
    data['received_orders'] = this.receivedOrders;
    data['partially_delivered_orders'] = this.partiallyDeliveredOrders;
    data['cancelled_orders'] = this.cancelledOrders;
    data['hire_all'] = this.hireAll;
    data['hire_requested'] = this.hireRequested;
    data['hire_hired'] = this.hireHired;
    data['hire_serviced'] = this.hireServiced;
    data['hire_damaged'] = this.hireDamaged;
    data['hire_canceled'] = this.hireCanceled;
    data['hire_available'] = this.hireAvailable;
    if (this.inventory != null) {
      data['inventory'] = this.inventory!.map((v) => v.toJson()).toList();
    }
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Inventory {
  String? name;
  String? amount;

  Inventory({this.name, this.amount});

  Inventory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}
