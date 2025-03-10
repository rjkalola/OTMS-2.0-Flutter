class DashboardResponse {
  bool? isSuccess;
  String? message;
  int? taskCount;
  int? pendingApprovalCount;
  bool? isVerifyComplete;
  int? teamId;
  String? teamName;
  String? shiftStartTime;
  String? shiftEndTime;
  bool? isWorking;
  List<ShiftBreaks>? shiftBreaks;
  String? shiftName;
  int? shiftType;
  String? shiftTypeName;
  int? shiftId;
  bool? isOwner;
  int? companyId;
  String? companyName;
  String? currencySymbol;
  int? getTimeSeconds;
  int? storeTimeSeconds;
  String? userCode;
  String? companyImage;
  int? userTypeId;
  int? tradeId;
  int? supervisorId;
  int? dailyRate;
  int? hourlyRate;
  String? image;
  String? imageMain;
  int? overallRating;
  int? workingSeconds;
  int? breakingSeconds;
  String? breakinDateTime;
  String? checkinDateTime;
  int? breakinId;
  int? breaklogSeconds;
  int? checkinId;
  int? checklogSeconds;
  String? projectName;
  List<WorkLogs>? breakLogs;
  List<WorkLogs>? workLogs;
  bool? onLeave;
  String? androidVersionCode;
  int? activeShiftWorkSeconds;
  int? activeShiftBreakSeconds;
  int? personalFeed;
  int? companyFeed;
  int? taskFeed;
  int? announcementUnreadCount;
  String? lastFeedTime;
  String? latestFeedTime;
  String? nextUpdateLocationNotificationTime;
  String? userUpdateLocationCount;
  bool? joinCompanyRequest;
  int? cartItems;
  int? todayEarning;
  int? priceworkEarning;

  DashboardResponse(
      {this.isSuccess,
      this.message,
      this.taskCount,
      this.pendingApprovalCount,
      this.isVerifyComplete,
      this.teamId,
      this.teamName,
      this.shiftStartTime,
      this.shiftEndTime,
      this.isWorking,
      this.shiftBreaks,
      this.shiftName,
      this.shiftType,
      this.shiftTypeName,
      this.shiftId,
      this.isOwner,
      this.companyId,
      this.companyName,
      this.currencySymbol,
      this.getTimeSeconds,
      this.storeTimeSeconds,
      this.userCode,
      this.companyImage,
      this.userTypeId,
      this.tradeId,
      this.supervisorId,
      this.dailyRate,
      this.hourlyRate,
      this.image,
      this.imageMain,
      this.overallRating,
      this.workingSeconds,
      this.breakingSeconds,
      this.breakinDateTime,
      this.checkinDateTime,
      this.breakinId,
      this.breaklogSeconds,
      this.checkinId,
      this.checklogSeconds,
      this.projectName,
      this.breakLogs,
      this.workLogs,
      this.onLeave,
      this.androidVersionCode,
      this.activeShiftWorkSeconds,
      this.activeShiftBreakSeconds,
      this.personalFeed,
      this.companyFeed,
      this.taskFeed,
      this.announcementUnreadCount,
      this.lastFeedTime,
      this.latestFeedTime,
      this.nextUpdateLocationNotificationTime,
      this.userUpdateLocationCount,
      this.joinCompanyRequest,
      this.cartItems,
      this.todayEarning,
      this.priceworkEarning});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    taskCount = json['task_count'];
    pendingApprovalCount = json['pending_approval_count'];
    isVerifyComplete = json['is_verify_complete'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    shiftStartTime = json['shift_start_time'];
    shiftEndTime = json['shift_end_time'];
    isWorking = json['is_working'];
    if (json['shift_breaks'] != null) {
      shiftBreaks = <ShiftBreaks>[];
      json['shift_breaks'].forEach((v) {
        shiftBreaks!.add(new ShiftBreaks.fromJson(v));
      });
    }
    shiftName = json['shift_name'];
    shiftType = json['shift_type'];
    shiftTypeName = json['shift_type_name'];
    shiftId = json['shift_id'];
    isOwner = json['is_owner'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    currencySymbol = json['currency_symbol'];
    getTimeSeconds = json['get_time_seconds'];
    storeTimeSeconds = json['store_time_seconds'];
    userCode = json['user_code'];
    companyImage = json['company_image'];
    userTypeId = json['user_type_id'];
    tradeId = json['trade_id'];
    supervisorId = json['supervisor_id'];
    dailyRate = json['daily_rate'];
    hourlyRate = json['hourly_rate'];
    image = json['image'];
    imageMain = json['image_main'];
    overallRating = json['overall_rating'];
    workingSeconds = json['working_seconds'];
    breakingSeconds = json['breaking_seconds'];
    breakinDateTime = json['breakin_date_time'];
    checkinDateTime = json['checkin_date_time'];
    breakinId = json['breakin_id'];
    breaklogSeconds = json['breaklog_seconds'];
    checkinId = json['checkin_id'];
    checklogSeconds = json['checklog_seconds'];
    projectName = json['project_name'];
    if (json['breakLogs'] != null) {
      breakLogs = <WorkLogs>[];
      json['breakLogs'].forEach((v) {
        breakLogs!.add(WorkLogs.fromJson(v));
      });
    }
    if (json['workLogs'] != null) {
      workLogs = <WorkLogs>[];
      json['workLogs'].forEach((v) {
        workLogs!.add(WorkLogs.fromJson(v));
      });
    }
    onLeave = json['onLeave'];
    androidVersionCode = json['android_version_code'];
    activeShiftWorkSeconds = json['active_shift_work_seconds'];
    activeShiftBreakSeconds = json['active_shift_break_seconds'];
    personalFeed = json['personal_feed'];
    companyFeed = json['company_feed'];
    taskFeed = json['task_feed'];
    announcementUnreadCount = json['announcement_unread_count'];
    lastFeedTime = json['last_feed_time'];
    latestFeedTime = json['latest_feed_time'];
    nextUpdateLocationNotificationTime =
        json['next_update_location_notification_time'];
    userUpdateLocationCount = json['user_update_location_count'];
    joinCompanyRequest = json['join_company_request'];
    cartItems = json['cart_items'];
    todayEarning = json['today_earning'];
    priceworkEarning = json['pricework_earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['task_count'] = this.taskCount;
    data['pending_approval_count'] = this.pendingApprovalCount;
    data['is_verify_complete'] = this.isVerifyComplete;
    data['team_id'] = this.teamId;
    data['team_name'] = this.teamName;
    data['shift_start_time'] = this.shiftStartTime;
    data['shift_end_time'] = this.shiftEndTime;
    data['is_working'] = this.isWorking;
    if (this.shiftBreaks != null) {
      data['shift_breaks'] = this.shiftBreaks!.map((v) => v.toJson()).toList();
    }
    data['shift_name'] = this.shiftName;
    data['shift_type'] = this.shiftType;
    data['shift_type_name'] = this.shiftTypeName;
    data['shift_id'] = this.shiftId;
    data['is_owner'] = this.isOwner;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['currency_symbol'] = this.currencySymbol;
    data['get_time_seconds'] = this.getTimeSeconds;
    data['store_time_seconds'] = this.storeTimeSeconds;
    data['user_code'] = this.userCode;
    data['company_image'] = this.companyImage;
    data['user_type_id'] = this.userTypeId;
    data['trade_id'] = this.tradeId;
    data['supervisor_id'] = this.supervisorId;
    data['daily_rate'] = this.dailyRate;
    data['hourly_rate'] = this.hourlyRate;
    data['image'] = this.image;
    data['image_main'] = this.imageMain;
    data['overall_rating'] = this.overallRating;
    data['working_seconds'] = this.workingSeconds;
    data['breaking_seconds'] = this.breakingSeconds;
    data['breakin_date_time'] = this.breakinDateTime;
    data['checkin_date_time'] = this.checkinDateTime;
    data['breakin_id'] = this.breakinId;
    data['breaklog_seconds'] = this.breaklogSeconds;
    data['checkin_id'] = this.checkinId;
    data['checklog_seconds'] = this.checklogSeconds;
    data['project_name'] = this.projectName;
    if (this.breakLogs != null) {
      data['breakLogs'] = this.breakLogs!.map((v) => v.toJson()).toList();
    }
    if (this.workLogs != null) {
      data['workLogs'] = this.workLogs!.map((v) => v.toJson()).toList();
    }
    data['onLeave'] = this.onLeave;
    data['android_version_code'] = this.androidVersionCode;
    data['active_shift_work_seconds'] = this.activeShiftWorkSeconds;
    data['active_shift_break_seconds'] = this.activeShiftBreakSeconds;
    data['personal_feed'] = this.personalFeed;
    data['company_feed'] = this.companyFeed;
    data['task_feed'] = this.taskFeed;
    data['announcement_unread_count'] = this.announcementUnreadCount;
    data['last_feed_time'] = this.lastFeedTime;
    data['latest_feed_time'] = this.latestFeedTime;
    data['next_update_location_notification_time'] =
        this.nextUpdateLocationNotificationTime;
    data['user_update_location_count'] = this.userUpdateLocationCount;
    data['join_company_request'] = this.joinCompanyRequest;
    data['cart_items'] = this.cartItems;
    data['today_earning'] = this.todayEarning;
    data['pricework_earning'] = this.priceworkEarning;
    return data;
  }
}

class ShiftBreaks {
  String? start;
  String? end;

  ShiftBreaks({this.start, this.end});

  ShiftBreaks.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

class WorkLogs {
  String? start;
  String? end;
  int? breakMinutes;
  int? workMinutes;
  int? shiftId;
  int? shiftType;

  WorkLogs(
      {this.start,
      this.end,
      this.breakMinutes,
      this.workMinutes,
      this.shiftId,
      this.shiftType});

  WorkLogs.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    breakMinutes = json['break_minutes'];
    workMinutes = json['work_minutes'];
    shiftId = json['shift_id'];
    shiftType = json['shift_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = this.start;
    data['end'] = this.end;
    data['break_minutes'] = this.breakMinutes;
    data['work_minutes'] = this.workMinutes;
    data['shift_id'] = this.shiftId;
    data['shift_type'] = this.shiftType;
    return data;
  }
}
