import 'package:belcka/pages/user_orders/storeman_catalog/model/get_product_images_data_model.dart';

class ProductCartListInfo {
  int? id;
  int? productId;
  int? companyId;
  String? companyName;
  String? uuid;
  String? sortName;
  String? name;
  String? price;
  int? qty;
  int? cartQty;
  String? currency;
  String? subTotal;
  String? productImage;
  String? productThumbImage;
  List<GetProductImagesDataModel>? productImages;

  ProductCartListInfo(
      {this.id,
        this.productId,
        this.companyId,
        this.companyName,
        this.uuid,
        this.sortName,
        this.name,
        this.price,
        this.qty,
        this.cartQty,
        this.currency,
        this.subTotal,
        this.productImage,
        this.productThumbImage,
        this.productImages});

  ProductCartListInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    uuid = json['uuid'];
    sortName = json['sort_name'];
    name = json['name'];
    price = json['price'].toString();
    qty = json['qty'];
    cartQty = json['cart_qty'];
    currency = json['currency'];
    subTotal = json['sub_total'].toString();
    productImage = json['product_image'];
    productThumbImage = json['product_thumb_image'];
    if (json['product_images'] != null) {
      productImages = <GetProductImagesDataModel>[];
      json['product_images'].forEach((v) {
        productImages!.add(new GetProductImagesDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['uuid'] = this.uuid;
    data['sort_name'] = this.sortName;
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['cart_qty'] = this.cartQty;
    data['currency'] = this.currency;
    data['sub_total'] = this.subTotal;
    data['product_image'] = this.productImage;
    data['product_thumb_image'] = this.productThumbImage;
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}