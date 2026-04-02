class CartProductData {
  final int productId;
  final int qty;
  final int cartQty;
  final int isSubQty;

  CartProductData({
    required this.productId,
    required this.qty,
    required this.cartQty,
    required this.isSubQty,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "qty": qty,
      "cart_qty": cartQty,
      "is_sub_qty": isSubQty,
    };
  }
}