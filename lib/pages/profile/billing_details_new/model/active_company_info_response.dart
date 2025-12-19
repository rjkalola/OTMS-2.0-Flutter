class ActiveCompanyInfoResponse {
  final bool isSuccess;
  final String message;
  final ActiveCompanyInfo info;

  ActiveCompanyInfoResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory ActiveCompanyInfoResponse.fromJson(Map<String, dynamic> json) {
    return ActiveCompanyInfoResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: ActiveCompanyInfo.fromJson(json['info'] ?? {}),
    );
  }
}

class ActiveCompanyInfo {
  String? currency;
  int? currencyId;
  String? image;
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  int? userId;
  String? userName;
  String? userImage;
  int? userRoleId;
  int? tradeId;
  String? tradeName;
  double? netRatePerDay;
  String? joiningDate;
  int? status;
  String? statusText;
  bool? isPendingRequest;
  DiffData? diffData;
  String? oldNetRatePerDay;
  String? newNetRatePerDay;
  int? requestLogId;

  ActiveCompanyInfo({
    this.currency,
    this.currencyId,
    this.image,
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.userId,
    this.userName,
    this.userImage,
    this.userRoleId,
    this.tradeId,
    this.tradeName,
    this.netRatePerDay,
    this.joiningDate,
    this.status,
    this.statusText,
    this.isPendingRequest,
    this.diffData,
    this.oldNetRatePerDay,
    this.newNetRatePerDay,
    this.requestLogId,
  });

  factory ActiveCompanyInfo.fromJson(Map<String, dynamic> json) {
    return ActiveCompanyInfo(
      currency: json['currency'] ?? '',
      currencyId: json['currency_id'] ?? 0,
      image: json['image'] ?? '',
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      userRoleId: json['user_role_id'] ?? 0,
      tradeId: json['trade_id'] ?? 0,
      tradeName: json['trade_name'] ?? '',
      netRatePerDay: (json['net_rate_perDay'] ?? 0).toDouble(),
      joiningDate: json['joining_date'] ?? '',
      status: json['status'] ?? 0,
      statusText: json['status_text'] ?? '',
      isPendingRequest: json['is_pending_request'] ?? false,
      diffData: DiffData.fromJson(json['diff_data'] ?? {}),
      oldNetRatePerDay: json['old_net_rate_perday'] ?? '',
      newNetRatePerDay: json['new_net_rate_perday'] ?? '',
      requestLogId: json['request_log_id'] ?? 0,
    );
  }
}

class DiffData {
  DiffValue? tradeId;
  DiffValue? tradeName;
  DiffValue? netRatePerDay;
  DiffValue? netRatePerHour;

  DiffData({
    this.tradeId,
    this.tradeName,
    this.netRatePerDay,
    this.netRatePerHour,
  });

  factory DiffData.fromJson(Map<String, dynamic> json) {
    return DiffData(
      tradeId: json['trade_id'] != null
          ? DiffValue.fromJson(json['trade_id'])
          : null,
      tradeName: json['trade_name'] != null
          ? DiffValue.fromJson(json['trade_name'])
          : null,
      netRatePerDay: json['net_rate_perday'] != null
          ? DiffValue.fromJson(json['net_rate_perday'])
          : null,
      netRatePerHour: json['net_rate_perhour'] != null
          ? DiffValue.fromJson(json['net_rate_perhour'])
          : null,
    );
  }
}

class DiffValue {
  dynamic oldValue;
  dynamic newValue;

  DiffValue({this.oldValue, this.newValue});

  factory DiffValue.fromJson(Map<String, dynamic> json) {
    return DiffValue(
      oldValue: json['old'],
      newValue: json['new'],
    );
  }
}