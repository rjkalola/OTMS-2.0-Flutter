import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_in_attachment_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';

class CheckLogInfo {
  int? id;
  int? userWorklogId;
  int? addressId;
  String? addressName;
  int? tradeId;
  String? tradeName;
  int? locationId;
  String? locationName;
  int? companyTaskTd;
  String? companyTaskName;
  String? dateAdded;
  String? checkinDateTime;
  String? checkoutDateTime;
  String? totalMinutes;
  int? totalWorkSeconds;
  LocationInfo? checkInLocation;
  LocationInfo? checkOutLocation;
  LocationInfo? circle;
  String? comment;
  List<CheckInAttachmentInfo>? beforeAttachments;
  List<CheckInAttachmentInfo>? afterAttachments;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? formattedCheckInTime;
  String? formattedCheckOutTime;
  int? totalCheckLogs;
  String? priceWorkTotalAmount;
  bool? isPricework, isAttachment;
  int? progress;
  List<TypeOfWorkResourcesInfo>? taskList;
  String? checkInNote;
  String? checkOutNote;

  CheckLogInfo(
      {this.id,
      this.userWorklogId,
      this.addressId,
      this.addressName,
      this.tradeId,
      this.tradeName,
      this.locationId,
      this.locationName,
      this.companyTaskTd,
      this.companyTaskName,
      this.dateAdded,
      this.checkinDateTime,
      this.checkoutDateTime,
      this.totalMinutes,
      this.totalWorkSeconds,
      this.checkInLocation,
      this.checkOutLocation,
      this.circle,
      this.comment,
      this.beforeAttachments,
      this.afterAttachments,
      this.formattedCheckInTime,
      this.formattedCheckOutTime,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.totalCheckLogs,
      this.priceWorkTotalAmount,
      this.isPricework,
      this.isAttachment,
      this.progress,
      this.taskList,
      this.checkInNote,
      this.checkOutNote});

  CheckLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userWorklogId = json['user_worklog_id'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    locationId = json['location_id'];
    locationName = json['location_name'];
    companyTaskTd = json['company_task_id'];
    companyTaskName = json['company_task_name'];
    dateAdded = json['date_added'];
    checkinDateTime = json['checkin_date_time'];
    checkoutDateTime = json['checkout_date_time'];
    totalMinutes = json['total_minutes'];
    totalWorkSeconds = json['total_work_seconds'];
    checkInLocation = json['check_in_location'] != null
        ? LocationInfo.fromJson(json['check_in_location'])
        : null;
    checkOutLocation = json['check_out_location'] != null
        ? LocationInfo.fromJson(json['check_out_location'])
        : null;
    circle =
        json['circle'] != null ? LocationInfo.fromJson(json['circle']) : null;
    comment = json['comment'];
    if (json['before_attachments'] != null) {
      beforeAttachments = <CheckInAttachmentInfo>[];
      json['before_attachments'].forEach((v) {
        beforeAttachments!.add(new CheckInAttachmentInfo.fromJson(v));
      });
    }
    if (json['after_attachments'] != null) {
      afterAttachments = <CheckInAttachmentInfo>[];
      json['after_attachments'].forEach((v) {
        afterAttachments!.add(new CheckInAttachmentInfo.fromJson(v));
      });
    }
    formattedCheckInTime = json['formatted_check_in_time'];
    formattedCheckOutTime = json['formatted_check_out_time'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    totalCheckLogs = json['total_checklogs'];
    priceWorkTotalAmount = json['pricework_total_amount'];
    isPricework = json['is_pricework'];
    isAttachment = json['is_attachment'];
    progress = json['progress'];
    if (json['task_list'] != null) {
      taskList = <TypeOfWorkResourcesInfo>[];
      json['task_list'].forEach((v) {
        taskList!.add(new TypeOfWorkResourcesInfo.fromJson(v));
      });
    }
    checkInNote = json['checkin_note'];
    checkOutNote = json['checkout_note'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_worklog_id'] = this.userWorklogId;
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['location_id'] = this.locationId;
    data['location_name'] = this.locationName;
    data['company_task_id'] = this.companyTaskTd;
    data['company_task_name'] = this.companyTaskName;
    data['date_added'] = this.dateAdded;
    data['checkin_date_time'] = this.checkinDateTime;
    data['checkout_date_time'] = this.checkoutDateTime;
    data['total_minutes'] = this.totalMinutes;
    data['total_work_seconds'] = this.totalWorkSeconds;
    if (this.checkInLocation != null) {
      data['check_in_location'] = this.checkInLocation!.toJson();
    }
    if (this.checkOutLocation != null) {
      data['check_out_location'] = this.checkOutLocation!.toJson();
    }
    if (this.circle != null) {
      data['circle'] = this.circle!.toJson();
    }
    data['comment'] = this.comment;
    if (this.beforeAttachments != null) {
      data['before_attachments'] =
          this.beforeAttachments!.map((v) => v.toJson()).toList();
    }
    if (this.afterAttachments != null) {
      data['after_attachments'] =
          this.afterAttachments!.map((v) => v.toJson()).toList();
    }
    data['formatted_check_in_time'] = this.formattedCheckInTime;
    data['formatted_check_out_time'] = this.formattedCheckOutTime;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['total_checklogs'] = this.totalCheckLogs;
    data['pricework_total_amount'] = this.priceWorkTotalAmount;
    data['is_pricework'] = this.isPricework;
    data['is_attachment'] = this.isAttachment;
    data['progress'] = this.progress;
    if (this.taskList != null) {
      data['task_list'] = this.taskList!.map((v) => v.toJson()).toList();
    }
    data['checkin_note'] = this.checkInNote;
    data['checkout_note'] = this.checkOutNote;
    return data;
  }
}
