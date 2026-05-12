class ProductSetModel {
  final int? id;
  final String? imageUrl;
  final String? thumbUrl;
  final int? setId;
  final String? setName;
  final int? productId;
  final String? productName;
  final String? displayPrice;
  final int? qty;
  final String? subQty;
  final bool? isSubQty;

  ProductSetModel({
    this.id,
    this.imageUrl,
    this.thumbUrl,
    this.setId,
    this.setName,
    this.productId,
    this.productName,
    this.displayPrice,
    this.qty,
    this.subQty,
    this.isSubQty,
  });

  factory ProductSetModel.fromJson(Map<String, dynamic> json) {
    return ProductSetModel(
      id: json['id'],
      imageUrl: json['image_url'],
      thumbUrl: json['thumb_url'],
      setId: json['set_id'],
      setName: json['set_name'],
      productId: json['product_id'],
      productName: json['product_name'],
      displayPrice: json['display_price'],
      qty: json['qty'],
      subQty: json['sub_qty'],
      isSubQty: json['is_sub_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'thumb_url': thumbUrl,
      'set_id': setId,
      'set_name': setName,
      'product_id': productId,
      'product_name': productName,
      'display_price': displayPrice,
      'qty': qty,
      'sub_qty': subQty,
      'is_sub_qty': isSubQty,
    };
  }
}