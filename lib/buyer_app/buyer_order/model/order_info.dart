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
  double? orderQty;
  double? qty;
  int? receiveQty;
  String? note;
  String? tax;
  int? status;
  String? statusText;
  String? statusColor;
  int? receivedBy;
  String? userName;
  String? userImage;
  int? orderBy;
  String? orderByName;
  String? orderByImage;
  int? approveBy;
  String? approveByUserName;
  String? approveByUserImage;
  List<ProductInfo>? purchaseOrders;
  String? orderNumber;
  bool? isDraft;

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
      this.qty,
      this.receiveQty,
      this.note,
      this.tax,
      this.status,
      this.statusText,
      this.statusColor,
      this.receivedBy,
      this.userName,
      this.userImage,
      this.orderBy,
      this.orderByName,
      this.orderByImage,
      this.approveBy,
      this.approveByUserName,
      this.approveByUserImage,
      this.purchaseOrders,
      this.orderNumber,
      this.isDraft});

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
    orderQty = (json['order_qty'] as num?)?.toDouble();
    qty = (json['qty'] as num?)?.toDouble();
    receiveQty = json['receive_qty'];
    note = json['note'];
    tax = json['tax'];
    status = json['status'];
    statusText = json['status_text'];
    statusColor = json['status_color'];
    receivedBy = json['received_by'];
    userName = json['user_name'];
    userImage = json['user_image'];
    orderBy = json['order_by'];
    orderByName = json['order_by_name'];
    orderByImage = json['order_by_image'];
    final dynamic approveByVal = json['approve_by'] ?? json['approved_by'];
    if (approveByVal is int) {
      approveBy = approveByVal;
    } else if (approveByVal != null) {
      approveBy = int.tryParse(approveByVal.toString());
    }
    approveByUserName = json['approve_by_user_name']?.toString();
    approveByUserImage = json['approve_by_user_image']?.toString();
    orderNumber = json['order_number'];
    isDraft = json['is_draft'];
    final dynamic purchaseOrdersData =
        json['purchase_orders'] ?? json['products'];
    if (purchaseOrdersData != null) {
      purchaseOrders = <ProductInfo>[];
      purchaseOrdersData.forEach((v) {
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
    data['qty'] = this.qty;
    data['receive_qty'] = this.receiveQty;
    data['note'] = this.note;
    data['tax'] = this.tax;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    data['status_color'] = this.statusColor;
    data['received_by'] = this.receivedBy;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['order_by'] = this.orderBy;
    data['order_by_name'] = this.orderByName;
    data['order_by_image'] = this.orderByImage;
    data['approve_by'] = this.approveBy;
    data['approve_by_user_name'] = this.approveByUserName;
    data['approve_by_user_image'] = this.approveByUserImage;
    data['order_number'] = this.orderNumber;
    data['is_draft'] = this.isDraft;
    if (this.purchaseOrders != null) {
      data['purchase_orders'] =
          this.purchaseOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
