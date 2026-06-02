import 'package:get_storage/get_storage.dart';

class CartService {
  static const String cartKey = "CART_ITEMS";

  final GetStorage storage = GetStorage();

  List<Map<String, dynamic>> getCartItems() {
    final data = storage.read(cartKey);

    if (data == null) return [];

    return List<Map<String, dynamic>>.from(data);
  }

  Map<String, dynamic>? getCartItem(int productId) {
    try {
      return getCartItems().firstWhere(
            (e) => e["product_id"] == productId,
      );
    } catch (_) {
      return null;
    }
  }

  void saveCartItems(List<Map<String, dynamic>> items) {
    storage.write(cartKey, items);
  }

  void addToCart(Map<String, dynamic> product) {
    final items = getCartItems();

    final index = items.indexWhere(
          (e) => e["product_id"] == product["product_id"],
    );

    if (index >= 0) {
      items[index]["cart_qty"] =
          (items[index]["cart_qty"] ?? 1) + 1;
    } else {
      product["cart_qty"] = 1;
      items.add(product);
    }

    saveCartItems(items);
  }

  void removeFromCart(int productId) {
    final items = getCartItems();

    items.removeWhere(
          (e) => e["product_id"] == productId,
    );

    saveCartItems(items);
  }

  void updateQty(int productId, int qty) {
    final items = getCartItems();

    final index = items.indexWhere(
          (e) => e["product_id"] == productId,
    );

    if (index == -1) return;

    if (qty <= 0) {
      items.removeAt(index);
    } else {
      items[index]["cart_qty"] = qty;
    }

    saveCartItems(items);
  }

  bool isProductAdded(int productId) {
    return getCartItems().any(
          (e) => e["product_id"] == productId,
    );
  }

  int getCartQty(int productId) {
    return getCartItem(productId)?["cart_qty"] ?? 0;
  }

  Map<int, Map<String, dynamic>> getCartMap() {
    final items = getCartItems();

    return {
      for (final item in items)
        item["product_id"]: item,
    };
  }

  void clearCart() {
    storage.remove(cartKey);
  }
}