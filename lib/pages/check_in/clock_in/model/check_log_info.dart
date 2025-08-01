import 'package:otm_inventory/pages/check_in/clock_in/model/check_in_attachment_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/location_info.dart';

class CheckLogInfo {
  int? id;
  int? userWorklogId;
  int? addressId;
  String? addressName;
  int? tradeId;
  String? tradeName;
  int? typeOfWorkId;
  String? typeOfWorkName;
  String? dateAdded;
  String? checkinDateTime;
  String? checkoutDateTime;
  String? totalMinutes;
  int? totalWorkSeconds;
  LocationInfo? checkInLocation;
  LocationInfo? checkOutLocation;
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

  CheckLogInfo(
      {this.id,
      this.userWorklogId,
      this.addressId,
      this.addressName,
      this.tradeId,
      this.tradeName,
      this.typeOfWorkId,
      this.typeOfWorkName,
      this.dateAdded,
      this.checkinDateTime,
      this.checkoutDateTime,
      this.totalMinutes,
      this.totalWorkSeconds,
      this.checkInLocation,
      this.checkOutLocation,
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
      this.priceWorkTotalAmount});

  CheckLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userWorklogId = json['user_worklog_id'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    typeOfWorkId = json['type_of_work_id'];
    typeOfWorkName = json['type_of_work_name'];
    dateAdded = json['date_added'];
    checkinDateTime = json['checkin_date_time'];
    checkoutDateTime = json['checkout_date_time'];
    totalMinutes = json['total_minutes'];
    totalWorkSeconds = json['total_work_seconds'];
    checkInLocation = json['check_in_location'] != null
        ? new LocationInfo.fromJson(json['check_in_location'])
        : null;
    checkOutLocation = json['check_out_location'] != null
        ? new LocationInfo.fromJson(json['check_out_location'])
        : null;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_worklog_id'] = this.userWorklogId;
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['type_of_work_id'] = this.typeOfWorkId;
    data['type_of_work_name'] = this.typeOfWorkName;
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
    return data;
  }
}
