import 'package:belcka/pages/common/model/file_info.dart';

class ExpenseInfo {
  int? id;
  int? companyId;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  int? addedBy;
  String? addedByUserName;
  String? addedByUserImage;
  String? addedByUserThumbImage;
  int? projectId;
  String? projectName;
  int? addressId;
  String? addressName;
  int? teamId;
  String? teamName;
  int? tradeId;
  String? tradeName;
  int? categoryId;
  String? categoryName;
  int? timesheetId;
  int? worklogId;
  String? dateAdded;
  String? receiptDate;
  double? totalAmount;
  String? currency;
  int? status;
  bool? isRequested;
  bool? isArchive;
  int? requestStatus;
  String? note;
  List<FilesInfo>? attachments;

  ExpenseInfo(
      {this.id,
      this.companyId,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.addedBy,
      this.addedByUserName,
      this.addedByUserImage,
      this.addedByUserThumbImage,
      this.projectId,
      this.projectName,
      this.addressId,
      this.addressName,
      this.teamId,
      this.teamName,
      this.tradeId,
      this.tradeName,
      this.categoryId,
      this.categoryName,
      this.timesheetId,
      this.worklogId,
      this.dateAdded,
      this.receiptDate,
      this.totalAmount,
      this.currency,
      this.status,
      this.isRequested,
      this.isArchive,
      this.requestStatus,
      this.note,
      this.attachments});

  ExpenseInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    addedBy = json['added_by'];
    addedByUserName = json['added_by_user_name'];
    addedByUserImage = json['added_by_user_image'];
    addedByUserThumbImage = json['added_by_user_thumb_image'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    timesheetId = json['timesheet_id'];
    worklogId = json['worklog_id'];
    dateAdded = json['date_added'];
    receiptDate = json['receipt_date'];
    // totalAmount = json['total_amount'];
    totalAmount = (json['total_amount'] is int)
        ? (json['total_amount'] as int).toDouble()
        : (json['total_amount'] is double)
            ? json['total_amount'] as double
            : 0.0;
    currency = json['currency'];
    status = json['status'];
    isRequested = json['is_requested'];
    isArchive = json['is_archive'];
    requestStatus = json['request_status'];
    note = json['note'];
    if (json['attachments'] != null) {
      attachments = <FilesInfo>[];
      json['attachments'].forEach((v) {
        attachments!.add(new FilesInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['added_by'] = this.addedBy;
    data['added_by_user_name'] = this.addedByUserName;
    data['added_by_user_image'] = this.addedByUserImage;
    data['added_by_user_thumb_image'] = this.addedByUserThumbImage;
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    data['team_id'] = this.teamId;
    data['team_name'] = this.teamName;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['timesheet_id'] = this.timesheetId;
    data['worklog_id'] = this.worklogId;
    data['date_added'] = this.dateAdded;
    data['receipt_date'] = this.receiptDate;
    data['total_amount'] = this.totalAmount;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['is_requested'] = this.isRequested;
    data['is_archive'] = this.isArchive;
    data['request_status'] = this.requestStatus;
    data['note'] = this.note;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
