import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class OrderDetailsOrdersInfo {
  int? id;
  int? orderId;
  int? productId;
  String? qty;
  String? price;
  int? receivedQty;
  double? remainingQty;
  String? productImage;
  String? productThumbImage;
  String? shortName;
  String? uuid;
  String? note;
  int? receiveId;
  String? description;
  ProductInfo? product;
  String? subQty;
  bool? isSubQty;

  OrderDetailsOrdersInfo({
    this.id,
    this.orderId,
    this.productId,
    this.qty,
    this.price,
    this.receivedQty,
    this.remainingQty,
    this.productImage,
    this.productThumbImage,
    this.shortName,
    this.uuid,
    this.note,
    this.receiveId,
    this.description,
    this.product,
    this.isSubQty,
    this.subQty
  });

  OrderDetailsOrdersInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    qty = json['qty'];
    price = json['price'];
    receivedQty = json['received_qty'];
    productImage = json['product_image'];
    productThumbImage = json['product_thumb_image'];
    shortName = json['short_name'];
    uuid = json['uuid'];
    note = json['note'];
    //receiveId = json['receiveId'];
    description = json['description'];
    subQty = json['sub_qty'].toString();
    isSubQty = json['is_sub_qty'];
    product = json['product'] != null
        ? ProductInfo.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['qty'] = qty;
    data['price'] = price;
    data['received_qty'] = receivedQty;
    data['remaining_qty'] = remainingQty;
    data['product_image'] = productImage;
    data['product_thumb_image'] = productThumbImage;
    data['short_name'] = shortName;
    data['uuid'] = uuid;
    data['note'] = note;
    data['receiveId'] = receiveId;
    data['description'] = description;
    data['product'] = product;
    data['is_sub_qty'] = isSubQty;
    data['sub_qty'] = subQty;
    return data;
  }
}