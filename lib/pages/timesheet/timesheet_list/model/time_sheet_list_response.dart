import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_info.dart';

class TimeSheetListResponse {
  bool? isSuccess;
  String? message;
  int? userId;
  int? companyId;
  String? currency;
  List<TimeSheetInfo>? info;

  TimeSheetListResponse(
      {this.isSuccess,
        this.message,
        this.userId,
        this.companyId,
        this.currency,
        this.info});

  TimeSheetListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userId = json['user_id'];
    companyId = json['company_id'];
    currency = json['currency'];
    if (json['info'] != null) {
      info = <TimeSheetInfo>[];
      json['info'].forEach((v) {
        info!.add(new TimeSheetInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['currency'] = this.currency;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
