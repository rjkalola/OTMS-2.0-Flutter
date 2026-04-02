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
  String? startDate;
  String? endDate;
  int? hireAll;
  int? hireRequested;
  int? hireHired;
  int? hireServiced;
  int? hireDamaged;
  int? hireCanceled;
  int? hireAvailable;

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
      this.startDate,
      this.endDate,
      this.hireAll,
      this.hireRequested,
      this.hireHired,
      this.hireServiced,
      this.hireDamaged,
      this.hireCanceled,
      this.hireAvailable});

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
    startDate = json['start_date'];
    endDate = json['end_date'];
    hireAll = _parseInt(json['hire_all']);
    hireRequested = _parseInt(json['hire_requested']);
    hireHired = _parseInt(json['hire_hired']);
    hireServiced = _parseInt(json['hire_serviced']);
    hireDamaged = _parseInt(json['hire_damaged']);
    hireCanceled = _parseInt(json['hire_canceled']);
    hireAvailable = _parseInt(json['hire_available']);
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
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
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['hire_all'] = this.hireAll;
    data['hire_requested'] = this.hireRequested;
    data['hire_hired'] = this.hireHired;
    data['hire_serviced'] = this.hireServiced;
    data['hire_damaged'] = this.hireDamaged;
    data['hire_canceled'] = this.hireCanceled;
    data['hire_available'] = this.hireAvailable;
    return data;
  }
}
