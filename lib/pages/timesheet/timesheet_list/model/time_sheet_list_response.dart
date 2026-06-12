import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class TimeSheetListResponse {
  bool? isSuccess;
  String? message;
  int? userId;
  int? companyId;
  String? currency;
  List<TimeSheetInfo>? info;
  PaginationData? pagination;

  TimeSheetListResponse(
      {this.isSuccess,
      this.message,
      this.userId,
      this.companyId,
      this.currency,
      this.info,
      this.pagination});

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
    pagination=  json['data'] != null ? PaginationData.fromJson(json['data']) : null;
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
