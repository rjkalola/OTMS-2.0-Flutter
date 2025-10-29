class AddressInfo {
  int? id;
  String? name;
  bool? isArchived;
  bool? isDeleted;
  int? statusInt;
  String? progress;
  String? statusText;
  int? projectId;
  String? projectName;
  int? trades;
  String? startDate;
  String? endDate;
  String? currency;
  int? priceWork;
  int? materials;
  String? dayWork;
  int? total;
  int? checkIns;
  double? latitude;
  double? longitude;
  int? radius;
  String? type;
  int? documents;

  AddressInfo(
      {this.id,
      this.name,
      this.isArchived,
      this.isDeleted,
      this.statusInt,
      this.progress,
      this.statusText,
      this.projectId,
      this.projectName,
      this.trades,
      this.startDate,
      this.endDate,
      this.currency,
      this.dayWork,
      this.checkIns,
      this.materials,
      this.priceWork,
      this.total,
      this.latitude,
      this.longitude,
      this.radius,
      this.type,
      this.documents});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isArchived = json['is_archived'];
    isDeleted = json['is_deleted'];
    statusInt = json['status_int'];
    progress = json['progress'];
    statusText = json['status_text'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    trades = json['trades'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    currency = json['currency'];
    priceWork = json['price_work'];
    materials = json['materials'];
    dayWork = json['day_work'];
    total = json['total'];
    checkIns = json['check_ins'];
    latitude = (json['latitude'] is int)
        ? (json['latitude'] as int).toDouble()
        : (json['latitude'] is double)
            ? json['latitude'] as double
            : 0.0;
    longitude = (json['longitude'] is int)
        ? (json['longitude'] as int).toDouble()
        : (json['longitude'] is double)
            ? json['longitude'] as double
            : 0.0;
    radius = json['radius'];
    type = json['type'];
    documents = json['documents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_archived'] = this.isArchived;
    data['is_deleted'] = this.isDeleted;
    data['status_int'] = this.statusInt;
    data['progress'] = this.progress;
    data['status_text'] = this.statusText;
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    data['trades'] = this.trades;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['currency'] = this.currency;
    data['price_work'] = this.priceWork;
    data['materials'] = this.materials;
    data['day_work'] = this.dayWork;
    data['total'] = this.total;
    data['check_ins'] = this.checkIns;
    data['documents'] = this.documents;

    return data;
  }
}
