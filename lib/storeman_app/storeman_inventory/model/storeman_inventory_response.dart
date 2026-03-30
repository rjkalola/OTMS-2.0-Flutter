class StoremanInventoryResponse {
  bool? isSuccess;
  String? message;
  int? upcoming;
  int? processing;
  int? onStock;
  int? supplierCancelled;
  int? supplierPartiallyDelivered;
  int? internalNew;
  int? internalPreparing;
  int? internalReady;
  int? internalCollect;
  int? hireNew;
  int? hireHired;
  int? hireAvailable;
  int? hireServicing;
  String? startDate;
  String? endDate;

  StoremanInventoryResponse(
      {this.isSuccess,
      this.message,
      this.upcoming,
      this.processing,
      this.onStock,
      this.supplierCancelled,
      this.supplierPartiallyDelivered,
      this.internalNew,
      this.internalPreparing,
      this.internalReady,
      this.internalCollect,
      this.hireNew,
      this.hireHired,
      this.hireAvailable,
      this.hireServicing,
      this.startDate,
      this.endDate});

  StoremanInventoryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    upcoming = json['supplier_upcoming'];
    processing = json['supplier_processing'];
    onStock = json['supplier_delivered'];
    supplierCancelled = json['supplier_canceled'];
    supplierPartiallyDelivered = json['supplier_partially_delivered'];
    internalNew = json['new'];
    internalPreparing = json['preparing'];
    internalReady = json['ready'];
    internalCollect = json['collected'];
    hireNew = json['hire_new'];
    hireHired = json['hire_hired'];
    hireAvailable = json['hire_available'];
    hireServicing = json['hire_servicing'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['upcoming'] = this.upcoming;
    data['processing'] = this.processing;
    data['on_stock'] = this.onStock;
    data['supplier_cancelled'] = this.supplierCancelled;
    data['supplier_partially_delivered'] = this.supplierPartiallyDelivered;
    data['internal_new'] = this.internalNew;
    data['internal_preparing'] = this.internalPreparing;
    data['internal_ready'] = this.internalReady;
    data['internal_collect'] = this.internalCollect;
    data['hire_new'] = this.hireNew;
    data['hire_hired'] = this.hireHired;
    data['hire_available'] = this.hireAvailable;
    data['hire_servicing'] = this.hireServicing;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
