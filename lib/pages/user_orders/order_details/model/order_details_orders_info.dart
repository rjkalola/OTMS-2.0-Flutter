import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class OrderDetailsOrdersInfo {
  int? id;
  int? orderId;
  int? productId;
  String? qty;
  String? price;
  int? receivedQty;
  String? remainingQty;
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
  String? marketPrice;
  String? currency;
  String? packOfUnit;
  String? packOfQty;
  bool isSelected = false;
  String? deliveredQty;
  int? status;
  bool isQuantityChanged = false;
  List<FilesInfo>? attachments;

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
    this.subQty,
    this.marketPrice,
    this.currency,
    this.packOfUnit,
    this.packOfQty,
    this.deliveredQty,
    this.status,
    this.attachments
  });

  OrderDetailsOrdersInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    qty = json['qty'].toString();
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
    marketPrice = json['market_price'].toString();
    currency = json['currency'];
    packOfUnit = json['pack_off_unit'];
    packOfQty = json['pack_off_qty'];
    deliveredQty = json['delivered_qty'].toString();
    remainingQty = json['remaining_qty'].toString();
    status = json['status'];
    product = json['product'] != null
        ? ProductInfo.fromJson(json['product'])
        : null;

    if (json['attachments'] != null) {
      attachments = <FilesInfo>[];
      json['attachments'].forEach((v) {
        attachments!.add(new FilesInfo.fromJson(v));
      });
    }
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
    data['market_price'] = marketPrice;
    data['currency'] = currency;
    data['pack_off_qty'] = packOfQty;
    data['pack_off_unit'] = packOfUnit;
    data['delivered_qty'] = deliveredQty;
    data['status'] = status;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}