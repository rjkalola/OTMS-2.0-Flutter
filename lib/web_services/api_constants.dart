class ApiConstants {
  static String appUrl = "https://api.otmsystem.com/v1";

  // static String appUrl = "https://apidev.otmsystem.com/v1";

  // static String appUrl = "https://dev.otmsystem.com/api/v1";
  // static String appUrl = "https://otmsystem.com/api/v1";

  static String accessToken = "";
  static const CODE_NO_INTERNET_CONNECTION = 10000;

  static Map<String, String> getHeader() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
      "Isinventory": "1",
    };
  }

  static String registerResourcesUrl = '$appUrl/wn-resources';
  static String verifyPhoneUrl = '$appUrl/verify-phone';
  static String loginUrl = '$appUrl/login-new';
  static String logoutUrl = '$appUrl/logout';
  static String getProductsUrl = '$appUrl/products/get';
  static String getProductResourcesUrl = '$appUrl/products/get-resources';
  static String storeProductUrl = '$appUrl/products/store';
  static String storeStockProductUrl = '$appUrl/products/store-barcode';
  static String getProductDetailsUrl = '$appUrl/products/edit-product';
  static String getStoreListUrl = '$appUrl/stores/get';
  static String getSupplierListUrl = '$appUrl/suppliers/get';
  static String getStoreResourcesUrl = '$appUrl/stores/get-resources';
  static String storeStoreUrl = '$appUrl/stores/store';
  static String getSuppliersResourcesUrl = '$appUrl/suppliers/get-resources';
  static String storeSupplierUrl = '$appUrl/suppliers/store';
  static String getCategoryListUrl = '$appUrl/categories/get';
  static String storeCategoryUrl = '$appUrl/categories/store';
  static String getStockQuantityDetailsUrl = '$appUrl/stocks/edit-qty';
  static String storeStockQuantityUrl = '$appUrl/stocks/store-qty';
  static String stockQuantityHistoryUrl = '$appUrl/stocks/history';
  static String addStockUrl = '$appUrl/stocks/add-stock';
  static String deleteProduct = '$appUrl/products/delete';
  static String archiveStock = '$appUrl/stocks/archive';
  static String deleteProductImage = '$appUrl/products/delete-attachment';
  static String stockFilterUrl = '$appUrl/products/category-filter';
  static String storeLocalStockUrl = '$appUrl/stocks/app-add-stock';
  static String getDashboardStockCount = '$appUrl/dashboard/get-count';
  static String storeMultipleProductUrl = '$appUrl/products/add-products';
  static String getLastProductUpdateTime = '$appUrl/products/latest-product';
  static String getSettingsUrl = '$appUrl/get-setting';
  static String getPurchaseOrders = '$appUrl/purchase-orders/get';
  static String receivePurchaseOrder = '$appUrl/purchase-orders/receive';
  static String storeLocalPurchaseOrderUrl =
      '$appUrl/purchase-orders/multiple-orders-receive';
}
