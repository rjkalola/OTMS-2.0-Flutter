class CompanySettingsResponse {
  bool? isSuccess;
  String? message;
  CompanySettingsData? data;
  List<PayRateUser>? payRateUsers;

  CompanySettingsResponse({
    this.isSuccess,
    this.message,
    this.data,
    this.payRateUsers,
  });

  CompanySettingsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    data = json['data'] != null
        ? CompanySettingsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
    if (json['pay_rate_users'] != null) {
      payRateUsers = <PayRateUser>[];
      (json['pay_rate_users'] as List).forEach((v) {
        payRateUsers!.add(PayRateUser.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (payRateUsers != null) {
      data['pay_rate_users'] = payRateUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanySettingsData {
  int? id;
  int? companyId;
  int? timezoneId;
  bool? isDayLimit;
  String? dailyLimit;
  bool? isAutoClock;
  bool? isOutsideBoundaryPenalty;
  String? outsideBoundaryPenaltyMinute;
  bool? isAutostopWorkPenalty;
  String? autostopWorkPenaltyMinute;
  String? autoClockOut;
  bool? showDiff;
  bool? highlightMore;
  bool? highlightLess;
  int? moreThanMinutes;
  int? lessThanMinutes;
  bool? showTimesheetRound;
  int? roundingIncrement;
  String? exportFormat;
  bool? payRatePermission;
  bool? isBillingDays;
  String? hrContactExtension;
  String? hrContactNumber;
  String? allowDayBillingInfo;
  String? payrollCycle;
  bool? isLeaveLimit;
  int? leaveLimit;
  bool? isCheckIn;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  TimezoneInfo? timezone;

  CompanySettingsData({
    this.id,
    this.companyId,
    this.timezoneId,
    this.isDayLimit,
    this.dailyLimit,
    this.isAutoClock,
    this.isOutsideBoundaryPenalty,
    this.outsideBoundaryPenaltyMinute,
    this.isAutostopWorkPenalty,
    this.autostopWorkPenaltyMinute,
    this.autoClockOut,
    this.showDiff,
    this.highlightMore,
    this.highlightLess,
    this.moreThanMinutes,
    this.lessThanMinutes,
    this.showTimesheetRound,
    this.roundingIncrement,
    this.exportFormat,
    this.payRatePermission,
    this.isBillingDays,
    this.hrContactExtension,
    this.hrContactNumber,
    this.allowDayBillingInfo,
    this.payrollCycle,
    this.isLeaveLimit,
    this.leaveLimit,
    this.isCheckIn,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.timezone,
  });

  CompanySettingsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    timezoneId = json['timezone_id'];
    isDayLimit = json['is_day_limit'];
    dailyLimit = json['daily_limit'];
    isAutoClock = json['is_auto_clock'];
    isOutsideBoundaryPenalty = json['is_outside_boundary_penalty'];
    outsideBoundaryPenaltyMinute = json['outside_boundary_penalty_minute'];
    isAutostopWorkPenalty = json['is_autostop_work_penalty'];
    autostopWorkPenaltyMinute = json['autostop_work_penalty_minute'];
    autoClockOut = json['auto_clock_out'];
    showDiff = json['show_diff'];
    highlightMore = json['highlight_more'];
    highlightLess = json['highlight_less'];
    moreThanMinutes = json['more_than_minutes'];
    lessThanMinutes = json['less_than_minutes'];
    showTimesheetRound = json['show_timesheet_round'];
    roundingIncrement = json['rounding_increment'];
    exportFormat = json['export_format'];
    payRatePermission = json['pay_rate_permission'];
    isBillingDays = json['is_billing_days'];
    hrContactExtension = json['hr_contact_extension'];
    hrContactNumber = json['hr_contact_number'];
    allowDayBillingInfo = json['allow_day_billing_info'];
    payrollCycle = json['payroll_cycle'];
    isLeaveLimit = json['is_leave_limit'];
    leaveLimit = json['leave_limit'];
    isCheckIn = json['is_check_in'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    timezone = json['timezone'] != null
        ? TimezoneInfo.fromJson(json['timezone'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['timezone_id'] = timezoneId;
    data['is_day_limit'] = isDayLimit;
    data['daily_limit'] = dailyLimit;
    data['is_auto_clock'] = isAutoClock;
    data['is_outside_boundary_penalty'] = isOutsideBoundaryPenalty;
    data['outside_boundary_penalty_minute'] = outsideBoundaryPenaltyMinute;
    data['is_autostop_work_penalty'] = isAutostopWorkPenalty;
    data['autostop_work_penalty_minute'] = autostopWorkPenaltyMinute;
    data['auto_clock_out'] = autoClockOut;
    data['show_diff'] = showDiff;
    data['highlight_more'] = highlightMore;
    data['highlight_less'] = highlightLess;
    data['more_than_minutes'] = moreThanMinutes;
    data['less_than_minutes'] = lessThanMinutes;
    data['show_timesheet_round'] = showTimesheetRound;
    data['rounding_increment'] = roundingIncrement;
    data['export_format'] = exportFormat;
    data['pay_rate_permission'] = payRatePermission;
    data['is_billing_days'] = isBillingDays;
    data['hr_contact_extension'] = hrContactExtension;
    data['hr_contact_number'] = hrContactNumber;
    data['allow_day_billing_info'] = allowDayBillingInfo;
    data['payroll_cycle'] = payrollCycle;
    data['is_leave_limit'] = isLeaveLimit;
    data['leave_limit'] = leaveLimit;
    data['is_check_in'] = isCheckIn;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (timezone != null) {
      data['timezone'] = timezone!.toJson();
    }
    return data;
  }
}

class TimezoneInfo {
  int? id;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  TimezoneInfo({
    this.id,
    this.name,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  TimezoneInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class PayRateUser {
  int? companyId;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;

  PayRateUser({
    this.companyId,
    this.userId,
    this.userName,
    this.userImage,
    this.userThumbImage,
  });

  PayRateUser.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    data['user_thumb_image'] = userThumbImage;
    return data;
  }
}
