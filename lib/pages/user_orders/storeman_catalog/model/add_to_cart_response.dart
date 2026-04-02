class AddToCartResponse {
  bool? isSuccess;
  String? message;
  int? cartProduct;
  List<AddToCartInfo>? info;

  AddToCartResponse({this.isSuccess, this.message, this.cartProduct, this.info});

  AddToCartResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProduct = json['cart_product'];

    if (json['info'] != null) {
      if (json['info'] is List) {
        info = (json['info'] as List)
            .map((e) => AddToCartInfo.fromJson(e))
            .toList();
      } else if (json['info'] is Map) {
        info = [AddToCartInfo.fromJson(json['info'])];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['message'] = message;
    data['cart_product'] = cartProduct;
    if (info != null) {
      data['info'] = info!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class AddToCartInfo {
  int? id;
  int? companyId;
  int? productId;
  int? userId;
  int? qty;
  int? subQty;
  double? price;
  double? subTotal;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  AddToCartInfo({
    this.id,
    this.companyId,
    this.productId,
    this.userId,
    this.qty,
    this.subQty,
    this.price,
    this.subTotal,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  AddToCartInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    productId = json['product_id'];
    userId = json['user_id'];
    qty = json['qty'];
    subQty = json['sub_qty'];
    price = json['price'] != null ? (json['price'] as num).toDouble() : null;
    subTotal =
        json['sub_total'] != null ? (json['sub_total'] as num).toDouble() : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['qty'] = qty;
    data['sub_qty'] = subQty;
    data['price'] = price;
    data['sub_total'] = subTotal;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
