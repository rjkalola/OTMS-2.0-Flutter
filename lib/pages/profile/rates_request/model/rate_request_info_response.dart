class RateRequestInfoResponse {
  bool? isSuccess;
  String? message;
  RateRequestInfo? info;

  RateRequestInfoResponse({this.isSuccess, this.message, this.info});

  RateRequestInfoResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new RateRequestInfo.fromJson(json['info']) : null;
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

class RateRequestInfo {
  int? id;
  String? currency;
  String? actionBy;
  int? status;
  String? statusText;
  String? oldNetRatePerday;
  String? newNetRatePerday;
  String? joiningDate;
  int? tradeId;
  String? tradeName;
  int? requestType;
  String? tableName;
  bool? isShow;
  String? oldTrade;
  String? newTrade;

  RateRequestInfo(
      {this.id,
        this.currency,
        this.actionBy,
        this.status,
        this.statusText,
        this.oldNetRatePerday,
        this.newNetRatePerday,
        this.joiningDate,
        this.tradeId,
        this.tradeName,
        this.requestType,
        this.tableName,
        this.isShow,
        this.newTrade,
        this.oldTrade});

  RateRequestInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    actionBy = json['action_by'];
    status = json['status'];
    statusText = json['status_text'];
    oldNetRatePerday = json['old_net_rate_perday'];
    newNetRatePerday = json['new_net_rate_perday'];
    joiningDate = json['joining_date'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    requestType = json['request_type'];
    tableName = json['table_name'];
    isShow = json['is_show'];
    oldTrade = json['old_trade'];
    newTrade = json['new_trade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currency'] = this.currency;
    data['action_by'] = this.actionBy;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    data['old_net_rate_perday'] = this.oldNetRatePerday;
    data['new_net_rate_perday'] = this.newNetRatePerday;
    data['joining_date'] = this.joiningDate;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['request_type'] = this.requestType;
    data['table_name'] = this.tableName;
    data['is_show'] = this.isShow;
    data['new_trade'] = this.newTrade;
    data['old_trade'] = this.oldTrade;
    return data;
  }
}