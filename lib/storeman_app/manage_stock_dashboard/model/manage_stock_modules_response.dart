class ManageStockModulesResponse {
  int? totalProducts;
  int? outOfStockCount;
  int? lowStockCount;
  int? minusStockCount;
  int? inStockCount;
  int? activeCompanyId;

  ManageStockModulesResponse({
    this.totalProducts,
    this.outOfStockCount,
    this.lowStockCount,
    this.minusStockCount,
    this.inStockCount,
    this.activeCompanyId,
  });

  factory ManageStockModulesResponse.fromJson(Map<String, dynamic> json) {
    return ManageStockModulesResponse(
      totalProducts: _parseInt(json['total_products']),
      outOfStockCount: _parseInt(json['out_of_stock_count']),
      lowStockCount: _parseInt(json['low_stock_count']),
      minusStockCount: _parseInt(json['minus_stock_count']),
      inStockCount: _parseInt(json['in_stock_count']),
      activeCompanyId: _parseInt(json['active_company_id']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
