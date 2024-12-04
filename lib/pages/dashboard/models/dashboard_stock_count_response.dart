class DashboardStockCountResponse {
  bool? isSuccess;
  String? message,
      data_size,
      all_total_amount,
      in_stock_count_total_amount,
      low_stock_count_total_amount,
      finishing_products_total_amount,
      out_of_stock_count_total_amount,
      minus_stock_count_total_amount,
      currency_symbol;
  int? inStockCount,
      lowStockCount,
      outOfStockCount,
      minusStockCount,
      issuedCount,
      receivedCount,
      partiallyReceived,
      cancelledCount,
      finishing_products;

  DashboardStockCountResponse({
    this.isSuccess,
    this.message,
    this.data_size,
    this.inStockCount,
    this.lowStockCount,
    this.outOfStockCount,
    this.minusStockCount,
    this.issuedCount,
    this.receivedCount,
    this.partiallyReceived,
    this.cancelledCount,
    this.finishing_products,
    this.all_total_amount,
    this.in_stock_count_total_amount,
    this.low_stock_count_total_amount,
    this.finishing_products_total_amount,
    this.out_of_stock_count_total_amount,
    this.minus_stock_count_total_amount,
    this.currency_symbol
  });

  DashboardStockCountResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    data_size = json['data_size'];
    inStockCount = json['in_stock_count'];
    lowStockCount = json['low_stock_count'];
    outOfStockCount = json['out_of_stock_count'];
    minusStockCount = json['minus_stock_count'];
    issuedCount = json['issued_count'];
    receivedCount = json['received_count'];
    partiallyReceived = json['partially_received'];
    cancelledCount = json['cancelled_count'];
    finishing_products = json['finishing_products'];
    all_total_amount = json['all_total_amount'];
    in_stock_count_total_amount = json['in_stock_count_total_amount'];
    low_stock_count_total_amount = json['low_stock_count_total_amount'];
    finishing_products_total_amount = json['finishing_products_total_amount'];
    out_of_stock_count_total_amount = json['out_of_stock_count_total_amount'];
    minus_stock_count_total_amount = json['minus_stock_count_total_amount'];
    currency_symbol= json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    data['data_size'] = data_size;
    data['in_stock_count'] = inStockCount;
    data['low_stock_count'] = lowStockCount;
    data['out_of_stock_count'] = outOfStockCount;
    data['minus_stock_count'] = minusStockCount;
    data['issued_count'] = issuedCount;
    data['received_count'] = receivedCount;
    data['partially_received'] = partiallyReceived;
    data['cancelled_count'] = cancelledCount;
    data['finishing_products'] = finishing_products;
    data['all_total_amount'] = all_total_amount;
    data['in_stock_count_total_amount'] = in_stock_count_total_amount;
    data['low_stock_count_total_amount'] = low_stock_count_total_amount;
    data['finishing_products_total_amount'] = finishing_products_total_amount;
    data['out_of_stock_count_total_amount'] = out_of_stock_count_total_amount;
    data['minus_stock_count_total_amount'] = minus_stock_count_total_amount;
    data['currency_symbol'] = currency_symbol;

    return data;
  }
}
