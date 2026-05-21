class ConflictsResponse {
  ConflictsResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  ConflictsResponse.fromJson(dynamic json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? ConflictsInfo.fromJson(json['info']) : null;
    activeCompanyId = json['active_company_id'];
  }

  bool? isSuccess;
  String? message;
  ConflictsInfo? info;
  int? activeCompanyId;
}

class ConflictsInfo {
  ConflictsInfo({
    this.totalConflicts,
    this.timesheetConflicts,
    this.billingConflicts,
    this.teamConflicts,
    this.healthSafetyConflicts,
    this.storeConflicts,
  });

  ConflictsInfo.fromJson(dynamic json) {
    totalConflicts = json['total_conflicts'];
    timesheetConflicts = json['timesheet_conflicts'] != null
        ? ConflictGroup.fromJson(json['timesheet_conflicts'])
        : ConflictGroup();
    billingConflicts = json['billing_conflicts'] != null
        ? ConflictGroup.fromJson(json['billing_conflicts'])
        : ConflictGroup();
    teamConflicts = json['team_conflicts'] != null
        ? TeamConflictGroup.fromJson(json['team_conflicts'])
        : TeamConflictGroup();
    healthSafetyConflicts = json['health_safety_conflicts'] != null
        ? HealthSafetyConflictGroup.fromJson(json['health_safety_conflicts'])
        : HealthSafetyConflictGroup();
    storeConflicts = json['store_conflicts'] != null
        ? StoreConflictGroup.fromJson(json['store_conflicts'])
        : StoreConflictGroup();
  }

  int? totalConflicts;
  ConflictGroup? timesheetConflicts;
  ConflictGroup? billingConflicts;
  TeamConflictGroup? teamConflicts;
  HealthSafetyConflictGroup? healthSafetyConflicts;
  StoreConflictGroup? storeConflicts;
}

class ConflictGroup {
  ConflictGroup({this.count, this.data});

  ConflictGroup.fromJson(dynamic json) {
    count = json['count'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserConflictData.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  int? count = 0;
  List<UserConflictData>? data = [];
}

class UserConflictData {
  UserConflictData({
    this.userId,
    this.userName,
    this.userImage,
    this.userThumbImage,
    this.formattedDate,
    this.date,
    this.items,
  });

  UserConflictData.fromJson(dynamic json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    formattedDate = json['formatted_date'];
    date = json['date'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(ConflictItem.fromJson(v));
      });
    } else {
      items = [];
    }
  }

  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? formattedDate;
  String? date;
  List<ConflictItem>? items = [];
}

class ConflictItem {
  ConflictItem({
    this.userId,
    this.date,
    this.worklogId,
    this.start,
    this.end,
    this.shiftName,
    this.shiftId,
    this.isLeave,
    this.leaveName,
    this.userLeaveId,
    this.conflictType,
    this.message,
    this.oldData,
    this.newData,
  });

  ConflictItem.fromJson(dynamic json) {
    userId = json['user_id'];
    date = json['date'];
    worklogId = json['worklog_id'];
    start = json['start'];
    end = json['end'];
    shiftName = json['shift_name'];
    shiftId = json['shift_id'];
    isLeave = json['is_leave'];
    leaveName = json['leave_name'];
    userLeaveId = json['user_leave_id'];
    conflictType = json['conflict_type'];
    message = json['message'];
    oldData = json['old_data'];
    newData = json['new_data'];
  }

  int? userId;
  String? date;
  int? worklogId;
  String? start;
  String? end;
  String? shiftName;
  int? shiftId;
  bool? isLeave;
  String? leaveName;
  int? userLeaveId;
  String? conflictType;
  String? message;
  dynamic oldData;
  dynamic newData;
}

class TeamConflictGroup {
  TeamConflictGroup({this.count, this.data});

  TeamConflictGroup.fromJson(dynamic json) {
    count = json['count'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TeamConflictData.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  int? count = 0;
  List<TeamConflictData>? data = [];
}

class TeamConflictData {
  TeamConflictData({
    this.teamId,
    this.teamName,
    this.supervisorId,
    this.supervisorName,
    this.supervisorImage,
    this.supervisorThumbImage,
    this.currentMemberCount,
    this.maxMemberLimit,
    this.conflictType,
  });

  TeamConflictData.fromJson(dynamic json) {
    teamId = json['team_id'];
    teamName = json['team_name'];
    supervisorId = json['supervisor_id'];
    supervisorName = json['supervisor_name'];
    supervisorImage = json['supervisor_image'];
    supervisorThumbImage = json['supervisor_thumb_image'];
    currentMemberCount = json['current_member_count'];
    maxMemberLimit = json['max_member_limit'];
    conflictType = json['conflict_type'];
  }

  int? teamId;
  String? teamName;
  int? supervisorId;
  String? supervisorName;
  String? supervisorImage;
  String? supervisorThumbImage;
  int? currentMemberCount;
  int? maxMemberLimit;
  String? conflictType;
}

class HealthSafetyConflictGroup {
  HealthSafetyConflictGroup({this.count, this.data});

  HealthSafetyConflictGroup.fromJson(dynamic json) {
    count = json['count'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(HealthSafetyConflictData.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  int? count = 0;
  List<HealthSafetyConflictData>? data = [];
}

class HealthSafetyConflictData {
  HealthSafetyConflictData({
    this.recordId,
    this.conflictType,
    this.message,
    this.reportedById,
    this.reportedByName,
    this.reportedByImage,
    this.reportedByThumbImage,
    this.hazardId,
    this.hazardName,
    this.description,
  });

  HealthSafetyConflictData.fromJson(dynamic json) {
    recordId = json['record_id'];
    conflictType = json['conflict_type'];
    message = json['message'];
    reportedById = json['reported_by_id'];
    reportedByName = json['reported_by_name'];
    reportedByImage = json['reported_by_image'];
    reportedByThumbImage = json['reported_by_thumb_image'];
    hazardId = json['hazard_id'];
    hazardName = json['hazard_name'];
    description = json['description'];
  }

  int? recordId;
  String? conflictType;
  String? message;
  int? reportedById;
  String? reportedByName;
  String? reportedByImage;
  String? reportedByThumbImage;
  int? hazardId;
  String? hazardName;
  String? description;
}

class StoreConflictGroup {
  StoreConflictGroup({this.qtyConflicts, this.amountConflicts});

  StoreConflictGroup.fromJson(dynamic json) {
    qtyConflicts = json['qty_conflicts'] != null
        ? StoreConflictList.fromJson(json['qty_conflicts'])
        : StoreConflictList();
    amountConflicts = json['amount_conflicts'] != null
        ? StoreConflictList.fromJson(json['amount_conflicts'])
        : StoreConflictList();
  }

  StoreConflictList? qtyConflicts = StoreConflictList();
  StoreConflictList? amountConflicts = StoreConflictList();
}

class StoreConflictList {
  StoreConflictList({this.count, this.data});

  StoreConflictList.fromJson(dynamic json) {
    count = json['count'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StoreConflictData.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  int? count = 0;
  List<StoreConflictData>? data = [];
}

class StoreConflictData {
  StoreConflictData({
    this.conflictType,
    this.productId,
    this.productName,
    this.productShortName,
    this.productImage,
    this.productThumbImage,
    this.storeId,
    this.storeName,
    this.currentQty,
    this.price,
    this.totalAmount,
    this.currency,
    this.message,
  });

  StoreConflictData.fromJson(dynamic json) {
    conflictType = json['conflict_type'];
    productId = json['product_id'];
    productName = json['product_name'];
    productShortName = json['product_short_name'];
    productImage = json['product_image'];
    productThumbImage = json['product_thumb_image'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    currentQty = (json['current_qty'] as num?)?.toDouble();
    price = json['price'];
    totalAmount = json['total_amount'];
    currency = json['currency'];
    message = json['message'];
  }

  String? conflictType;
  int? productId;
  String? productName;
  String? productShortName;
  String? productImage;
  String? productThumbImage;
  int? storeId;
  String? storeName;
  double? currentQty;
  String? price;
  String? totalAmount;
  String? currency;
  String? message;
}
