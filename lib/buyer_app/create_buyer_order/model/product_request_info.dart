class ProductRequestInfo {
  int? productId;
  int? qty;
  String? price;

  ProductRequestInfo({
    this.productId,
    this.qty,
    this.price,
  });

  factory ProductRequestInfo.fromJson(Map<String, dynamic> json) {
    return ProductRequestInfo(
      productId: json['product_id'] ?? 0,
      qty: json['qty'] ?? '',
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'qty': qty,
      'price': price,
    };
  }
}
