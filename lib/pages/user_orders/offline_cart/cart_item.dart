class CartItem {
  final int productId;
  final int companyId;

  final String productName;
  final String imageUrl;
  final String currency;

  double qty;
  int cartQty;
  double price;
  bool isSubQty;

  CartItem({
    required this.productId,
    required this.companyId,
    required this.productName,
    required this.imageUrl,
    required this.currency,
    required this.qty,
    required this.cartQty,
    required this.price,
    required this.isSubQty,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'companyId': companyId,
      'productName': productName,
      'imageUrl': imageUrl,
      'currency': currency,
      'qty': qty,
      'cartQty': cartQty,
      'price': price,
      'isSubQty': isSubQty,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      companyId: json['companyId'],
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      currency: json['currency'],
      qty: (json['qty'] as num).toDouble(),
      cartQty: json['cartQty'],
      price: (json['price'] as num).toDouble(),
      isSubQty: json['isSubQty'],
    );
  }
}