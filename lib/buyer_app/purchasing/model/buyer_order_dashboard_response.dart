class BuyerOrderDashboardResponse {
  bool? isSuccess;
  String? message;
  int? lowStock;
  int? outOfStock;
  int? damagedStock;
  int? uncompletedStock;
  int? products;
  int? stores;
  int? categories;
  int? suppliers;
  int? requestedOrders;
  int? proceedOrders;
  int? receivedOrders;
  List<Inventory>? inventory;

  BuyerOrderDashboardResponse(
      {this.isSuccess,
      this.message,
      this.lowStock,
      this.outOfStock,
      this.damagedStock,
      this.uncompletedStock,
      this.products,
      this.stores,
      this.categories,
      this.suppliers,
      this.requestedOrders,
      this.proceedOrders,
      this.receivedOrders,
      this.inventory});

  BuyerOrderDashboardResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    lowStock = json['low_stock'];
    outOfStock = json['out_of_stock'];
    damagedStock = json['damaged_stock'];
    uncompletedStock = json['uncompleted_stock'];
    products = json['products'];
    stores = json['stores'];
    categories = json['categories'];
    suppliers = json['suppliers'];
    requestedOrders = json['requested_orders'];
    proceedOrders = json['proceed_orders'];
    receivedOrders = json['received_orders'];
    if (json['inventory'] != null) {
      inventory = <Inventory>[];
      json['inventory'].forEach((v) {
        inventory!.add(new Inventory.fromJson(v));
      });
    }
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
    data['stores'] = this.stores;
    data['categories'] = this.categories;
    data['suppliers'] = this.suppliers;
    data['requested_orders'] = this.requestedOrders;
    data['proceed_orders'] = this.proceedOrders;
    data['received_orders'] = this.receivedOrders;
    if (this.inventory != null) {
      data['inventory'] = this.inventory!.map((v) => v.toJson()).toList();
    }
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
