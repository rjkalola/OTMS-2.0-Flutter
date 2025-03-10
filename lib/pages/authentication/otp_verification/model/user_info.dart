import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserInfo {
  int? id;
  String? userIdEnc;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? image;
  String? user_image;
  String? imageThumb;
  String? email;
  String? phone;
  @JsonKey(fromJson: _stringToInt, toJson: _stringFromInt)
  int? phoneExtensionId;
  String? birthDate;
  int? timezoneId;
  bool? isImageValid;
  String? phoneExtension;
  int? badgeCount;
  String? utrName;
  String? utr;
  int? workingStatus;
  String? createdAt;
  int? companyId;
  bool? isOwner;
  String? companyName;
  String? companyCode;
  String? userCode;
  String? companyImage;
  int? userTypeId;
  int? tradeId;
  int? supervisorId;
  int? invitedBy;
  int? dailyRate;
  int? hourlyRate;
  bool? updateLocationReminderHourCheck;
  bool? timesheetPriceworkExpenseNotification;
  bool? locationBoundaryNotification;
  String? apiToken;
  String? role;
  String? password;
  String? storedFeedTime;

  UserInfo(
      {this.id,
      this.userIdEnc,
      this.name,
      this.firstName,
      this.middleName,
      this.lastName,
      this.image,
      this.user_image,
      this.imageThumb,
      this.email,
      this.phone,
      this.phoneExtensionId,
      this.birthDate,
      this.timezoneId,
      this.isImageValid,
      this.phoneExtension,
      this.badgeCount,
      this.utrName,
      this.utr,
      this.workingStatus,
      this.createdAt,
      this.companyId,
      this.isOwner,
      this.companyName,
      this.companyCode,
      this.userCode,
      this.companyImage,
      this.userTypeId,
      this.tradeId,
      this.supervisorId,
      this.invitedBy,
      this.dailyRate,
      this.hourlyRate,
      this.updateLocationReminderHourCheck,
      this.timesheetPriceworkExpenseNotification,
      this.locationBoundaryNotification,
      this.apiToken,
      this.role,
      this.password,
      this.storedFeedTime});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userIdEnc = json['user_id_enc'];
    name = json['name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    image = json['image'];
    user_image = json['user_image'];
    imageThumb = json['image_thumb'];
    email = json['email'];
    phone = json['phone'];
    phoneExtensionId = json['phone_extension_id'];
    birthDate = json['birth_date'];
    timezoneId = json['timezone_id'];
    isImageValid = json['is_image_valid'];
    phoneExtension = json['phone_extension'];
    badgeCount = json['badge_count'];
    utrName = json['utr_name'];
    utr = json['utr'];
    workingStatus = json['working_status'];
    createdAt = json['created_at'];
    companyId = json['company_id'];
    isOwner = json['is_owner'];
    companyName = json['company_name'];
    companyCode = json['company_code'];
    userCode = json['user_code'];
    companyImage = json['company_image'];
    userTypeId = json['user_type_id'];
    tradeId = json['trade_id'];
    supervisorId = json['supervisor_id'];
    invitedBy = json['invited_by'];
    dailyRate = json['daily_rate'];
    hourlyRate = json['hourly_rate'];
    updateLocationReminderHourCheck =
        json['update_location_reminder_hour_check'];
    timesheetPriceworkExpenseNotification =
        json['timesheet_pricework_expense_notification'];
    locationBoundaryNotification = json['location_boundary_notification'];
    apiToken = json['api_token'];
    role = json['role'];
    password = json['password'];
    storedFeedTime = json['stored_feed_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id_enc'] = this.userIdEnc;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['user_image'] = this.user_image;
    data['image_thumb'] = this.imageThumb;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['phone_extension_id'] = this.phoneExtensionId;
    data['birth_date'] = this.birthDate;
    data['timezone_id'] = this.timezoneId;
    data['is_image_valid'] = this.isImageValid;
    data['phone_extension'] = this.phoneExtension;
    data['badge_count'] = this.badgeCount;
    data['utr_name'] = this.utrName;
    data['utr'] = this.utr;
    data['working_status'] = this.workingStatus;
    data['created_at'] = this.createdAt;
    data['company_id'] = this.companyId;
    data['is_owner'] = this.isOwner;
    data['company_name'] = this.companyName;
    data['company_code'] = this.companyCode;
    data['user_code'] = this.userCode;
    data['company_image'] = this.companyImage;
    data['user_type_id'] = this.userTypeId;
    data['trade_id'] = this.tradeId;
    data['supervisor_id'] = this.supervisorId;
    data['invited_by'] = this.invitedBy;
    data['daily_rate'] = this.dailyRate;
    data['hourly_rate'] = this.hourlyRate;
    data['update_location_reminder_hour_check'] =
        this.updateLocationReminderHourCheck;
    data['timesheet_pricework_expense_notification'] =
        this.timesheetPriceworkExpenseNotification;
    data['location_boundary_notification'] = this.locationBoundaryNotification;
    data['api_token'] = this.apiToken;
    data['role'] = this.role;
    data['password'] = this.password;
    data['stored_feed_time'] = this.storedFeedTime;
    return data;
  }

  static int? _stringToInt(String number) =>
      number == null ? null : int.parse(number);

  static String? _stringFromInt(int number) => number?.toString();
}
