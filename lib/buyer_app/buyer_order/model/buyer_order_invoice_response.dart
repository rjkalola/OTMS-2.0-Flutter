class BuyerOrderInvoiceResponse {
  bool? isSuccess;
  String? message;
  String? invoicePath;
  String? invoice;

  BuyerOrderInvoiceResponse(
      {this.isSuccess, this.message, this.invoicePath, this.invoice});

  BuyerOrderInvoiceResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    invoicePath = json['invoice_path'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['invoice_path'] = this.invoicePath;
    data['invoice'] = this.invoice;
    return data;
  }
}
