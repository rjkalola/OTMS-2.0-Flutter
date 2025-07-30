class AddressDetailsInfoResponse{
  bool? isSuccess;
  String? message;
  AddressDetailsInfo? info;

  AddressDetailsInfoResponse({this.isSuccess, this.message, this.info});

  AddressDetailsInfoResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new AddressDetailsInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class AddressDetailsInfo{
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
  List<Checklog>? checklog;
  String? startDate;
  String? endDate;

  AddressDetailsInfo(
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
        this.checklog,
        this.startDate,
        this.endDate});

  AddressDetailsInfo.fromJson(Map<String, dynamic> json) {
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
    /*
    if (json['checklog'] != null) {
      checklog = <Checklog>[];
      json['checklog'].forEach((v) {
        checklog!.add(new Checklog.fromJson(v));
      });
    }
    */
    startDate = json['start_date'];
    endDate = json['end_date'];
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

    if (this.checklog != null) {
      //data['checklog'] = this.checklog!.map((v) => v.toJson()).toList();
    }

    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Checklog {
  int? id;
  int? userWorklogId;
  Null? projectId;
  int? addressId;
  int? tradeId;
  Null? typeOfWorkId;
  String? dateAdded;
  String? checkinDateTime;
  String? checkoutDateTime;
  String? checkinLocation;
  String? checkinLatitude;
  String? checkinLongitude;
  String? checkoutLocation;
  String? checkoutLatitude;
  String? checkoutLongitude;
  String? totalMinutes;
  String? status;
  Null? comment;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Checklog(
      {this.id,
        this.userWorklogId,
        this.projectId,
        this.addressId,
        this.tradeId,
        this.typeOfWorkId,
        this.dateAdded,
        this.checkinDateTime,
        this.checkoutDateTime,
        this.checkinLocation,
        this.checkinLatitude,
        this.checkinLongitude,
        this.checkoutLocation,
        this.checkoutLatitude,
        this.checkoutLongitude,
        this.totalMinutes,
        this.status,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Checklog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userWorklogId = json['user_worklog_id'];
    projectId = json['project_id'];
    addressId = json['address_id'];
    tradeId = json['trade_id'];
    typeOfWorkId = json['type_of_work_id'];
    dateAdded = json['date_added'];
    checkinDateTime = json['checkin_date_time'];
    checkoutDateTime = json['checkout_date_time'];
    checkinLocation = json['checkin_location'];
    checkinLatitude = json['checkin_latitude'];
    checkinLongitude = json['checkin_longitude'];
    checkoutLocation = json['checkout_location'];
    checkoutLatitude = json['checkout_latitude'];
    checkoutLongitude = json['checkout_longitude'];
    totalMinutes = json['total_minutes'];
    status = json['status'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_worklog_id'] = this.userWorklogId;
    data['project_id'] = this.projectId;
    data['address_id'] = this.addressId;
    data['trade_id'] = this.tradeId;
    data['type_of_work_id'] = this.typeOfWorkId;
    data['date_added'] = this.dateAdded;
    data['checkin_date_time'] = this.checkinDateTime;
    data['checkout_date_time'] = this.checkoutDateTime;
    data['checkin_location'] = this.checkinLocation;
    data['checkin_latitude'] = this.checkinLatitude;
    data['checkin_longitude'] = this.checkinLongitude;
    data['checkout_location'] = this.checkoutLocation;
    data['checkout_latitude'] = this.checkoutLatitude;
    data['checkout_longitude'] = this.checkoutLongitude;
    data['total_minutes'] = this.totalMinutes;
    data['status'] = this.status;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}