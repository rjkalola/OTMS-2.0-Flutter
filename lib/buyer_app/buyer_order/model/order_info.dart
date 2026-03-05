import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class OrderInfo {
  int? id;
  int? companyId;
  String? companyName;
  String? companyImage;
  String? currency;
  String? orderId;
  String? invoice;
  String? ref;
  int? storeId;
  String? storeName;
  int? supplierId;
  String? supplierName;
  String? date;
  String? expectedDeliveryDate;
  String? totalAmount;
  int? orderQty;
  int? receiveQty;
  String? note;
  String? tax;
  int? status;
  String? statusText;
  String? statusColor;
  int? receivedBy;
  String? userName;
  String? userImage;
  List<ProductInfo>? purchaseOrders;

  String? orderNumber;

  OrderInfo(
      {this.id,
      this.companyId,
      this.companyName,
      this.companyImage,
      this.currency,
      this.orderId,
      this.invoice,
      this.ref,
      this.storeId,
      this.storeName,
      this.supplierId,
      this.supplierName,
      this.date,
      this.expectedDeliveryDate,
      this.totalAmount,
      this.orderQty,
      this.receiveQty,
      this.note,
      this.tax,
      this.status,
      this.statusText,
      this.statusColor,
      this.receivedBy,
      this.userName,
      this.userImage,
      this.purchaseOrders,
      this.orderNumber});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyImage = json['company_image'];
    currency = json['currency'];
    orderId = json['order_id'].toString();
    invoice = json['invoice'];
    ref = json['ref'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    date = json['date'];
    expectedDeliveryDate = json['expected_delivery_date'];
    totalAmount = json['total_amount'];
    orderQty = json['order_qty'];
    receiveQty = json['receive_qty'];
    note = json['note'];
    tax = json['tax'];
    status = json['status'];
    statusText = json['status_text'];
    statusColor = json['status_color'];
    receivedBy = json['received_by'];
    userName = json['user_name'];
    userImage = json['user_image'];
    orderNumber = json['order_number'];
    if (json['purchase_orders'] != null) {
      purchaseOrders = <ProductInfo>[];
      json['purchase_orders'].forEach((v) {
        purchaseOrders!.add(new ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['company_image'] = this.companyImage;
    data['currency'] = this.currency;
    data['order_id'] = this.orderId;
    data['invoice'] = this.invoice;
    data['ref'] = this.ref;
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['supplier_id'] = this.supplierId;
    data['supplier_name'] = this.supplierName;
    data['date'] = this.date;
    data['expected_delivery_date'] = this.expectedDeliveryDate;
    data['total_amount'] = this.totalAmount;
    data['order_qty'] = this.orderQty;
    data['receive_qty'] = this.receiveQty;
    data['note'] = this.note;
    data['tax'] = this.tax;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    data['status_color'] = this.statusColor;
    data['received_by'] = this.receivedBy;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['order_number'] = this.orderNumber;
    if (this.purchaseOrders != null) {
      data['purchase_orders'] =
          this.purchaseOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
