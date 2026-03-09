class StoremanInventoryResponse {
  bool? isSuccess;
  String? message;
  int? upcoming;
  int? processing;
  int? onStock;
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
    upcoming = json['upcoming'];
    processing = json['processing'];
    onStock = json['on_stock'];
    internalNew = json['internal_new'];
    internalPreparing = json['internal_preparing'];
    internalReady = json['internal_ready'];
    internalCollect = json['internal_collect'];
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

