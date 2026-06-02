import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String cartKey = "cart_items";

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(cartKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    return List<Map<String, dynamic>>.from(
      jsonDecode(data),
    );
  }

  Future<Map<String, dynamic>?> getCartItem(
      int productId,
      ) async {

    final items = await getCartItems();

    try {
      return items.firstWhere(
            (e) => e["product_id"] == productId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCartItems(
      List<Map<String, dynamic>> items,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      cartKey,
      jsonEncode(items),
    );
  }

  Future<void> addToCart(
      Map<String, dynamic> product,
      ) async {
    final items = await getCartItems();
    final index = items.indexWhere(
          (e) => e["product_id"] == product["product_id"],
    );
    if (index >= 0) {
      items[index]["cart_qty"] =
          (items[index]["cart_qty"] ?? 1) + 1;

    }else{
      product["cart_qty"] = 1;
      items.add(product);
    }
    await saveCartItems(items);
  }

  Future<void> removeFromCart(int productId,) async {
    final items = await getCartItems();
    items.removeWhere(
          (e) => e["product_id"] == productId,
    );

    await saveCartItems(items);
  }

  Future<void> updateQty(int productId, int qty,) async{
    final items = await getCartItems();
    final index = items.indexWhere(
          (e) => e["product_id"] == productId,
    );
    if (index == -1) return;
    if (qty <= 0) {
      items.removeAt(index);
    }
    else{
      items[index]["cart_qty"] = qty;
    }
    await saveCartItems(items);
  }

  Future<bool> isProductAdded(
      int productId,
      ) async {

    final items = await getCartItems();

    return items.any(
          (e) => e["product_id"] == productId,
    );
  }
  Future<int> getCartQty(int productId,) async {
    final item = await getCartItem(
      productId,
    );
    return item?["cart_qty"] ?? 0;
  }

  Future<Map<int, Map<String, dynamic>>> getCartMap() async {
    final items = await getCartItems();

    return{
      for (final item in items)
        item["product_id"]: item,
    };
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }
}