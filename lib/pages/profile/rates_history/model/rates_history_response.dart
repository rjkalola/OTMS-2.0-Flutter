class RatesHistoryResponse {
  bool? isSuccess;
  String? message;
  List<RatesHistoryInfo>? info;

  RatesHistoryResponse({this.isSuccess, this.message, this.info});

  RatesHistoryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <RatesHistoryInfo>[];
      json['info'].forEach((v) {
        info!.add(new RatesHistoryInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatesHistoryInfo{
  int? id;
  int? userId;
  String? name;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? currency;
  String? effectiveDate;
  String? date;
  String? time;
  int? status;
  String? statusText;
  String? actionBy;
  String? note;
  int? requestType;
  String? typeName;
  String? tableName;
  String? oldNetRatePerday;
  String? newNetRatePerday;

  RatesHistoryInfo(
      {this.id,
        this.userId,
        this.name,
        this.userName,
        this.userImage,
        this.userThumbImage,
        this.currency,
        this.effectiveDate,
        this.date,
        this.time,
        this.status,
        this.statusText,
        this.actionBy,
        this.note,
        this.requestType,
        this.typeName,
        this.tableName,
        this.oldNetRatePerday,
        this.newNetRatePerday});

  RatesHistoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    currency = json['currency'];
    effectiveDate = json['effective_date'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    statusText = json['status_text'];
    actionBy = json['action_by'];
    note = json['note'];
    requestType = json['request_type'];
    typeName = json['type_name'];
    tableName = json['table_name'];
    oldNetRatePerday = json['old_net_rate_perday'];
    newNetRatePerday = json['new_net_rate_perday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['currency'] = this.currency;
    data['effective_date'] = this.effectiveDate;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    data['action_by'] = this.actionBy;
    data['note'] = this.note;
    data['request_type'] = this.requestType;
    data['type_name'] = this.typeName;
    data['table_name'] = this.tableName;
    data['old_net_rate_perday'] = this.oldNetRatePerday;
    data['new_net_rate_perday'] = this.newNetRatePerday;
    return data;
  }
}