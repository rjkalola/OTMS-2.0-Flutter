import 'package:belcka/pages/user_orders/order_details/model/order_details_orders_info.dart';

class OrderDetailsInfo {
  int? id;
  int? companyId;
  String? companyName;
  String? companyImage;
  String? currency;
  String? totalAmount;
  String? orderId;
  double? orderQty;
  int? receiveQty;
  String? note;
  int? projectId;
  String? projectName;
  int? addressId;
  String? addressName;
  String? userName;
  String? userImage;
  int? status;
  String? statusText;
  String? statusColor;
  int? statusUpdatedBy;
  String? updatedBy;
  String? date;
  List<OrderDetailsOrdersInfo>? orders;
  int? storeId;
  String? deliverOn;

  OrderDetailsInfo({
    this.id,
    this.companyId,
    this.companyName,
    this.companyImage,
    this.currency,
    this.totalAmount,
    this.orderId,
    this.orderQty,
    this.receiveQty,
    this.note,
    this.projectId,
    this.projectName,
    this.addressId,
    this.addressName,
    this.userName,
    this.userImage,
    this.status,
    this.statusText,
    this.statusColor,
    this.statusUpdatedBy,
    this.updatedBy,
    this.date,
    this.orders,
    this.deliverOn,
    this.storeId
  });

  OrderDetailsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyImage = json['company_image'];
    currency = json['currency'];
    totalAmount = json['total_amount'];
    orderId = json['order_id'];
    orderQty = (json['order_qty'] as num?)?.toDouble();
    receiveQty = json['receive_qty'];
    note = json['note'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    userName = json['user_name'];
    userImage = json['user_image'];
    status = json['status'];
    statusText = json['status_text'];
    statusColor = json['status_color'];
    statusUpdatedBy = json['status_updated_by'];
    updatedBy = json['updated_by'];
    date = json['date'];
    deliverOn = json['deliver_on'];
    storeId = json['store_id'];

    if (json['orders'] != null) {
      orders = <OrderDetailsOrdersInfo>[];
      json['orders'].forEach((v) {
        orders!.add(OrderDetailsOrdersInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['company_image'] = companyImage;
    data['currency'] = currency;
    data['total_amount'] = totalAmount;
    data['order_id'] = orderId;
    data['order_qty'] = orderQty;
    data['receive_qty'] = receiveQty;
    data['note'] = note;
    data['project_id'] = projectId;
    data['project_name'] = projectName;
    data['address_id'] = addressId;
    data['address_name'] = addressName;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    data['status'] = status;
    data['status_text'] = statusText;
    data['status_color'] = statusColor;
    data['status_updated_by'] = statusUpdatedBy;
    data['updated_by'] = updatedBy;
    data['date'] = date;

    data['deliver_on'] = deliverOn;
    data['store_id'] = storeId;

    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}