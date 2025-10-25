import 'package:belcka/pages/leaves/add_leave/model/leave_type_info.dart';

class LeaveTypeListResponse {
  bool? isSuccess;
  String? message;
  List<LeaveTypeInfo>? info;

  LeaveTypeListResponse({this.isSuccess, this.message, this.info});

  LeaveTypeListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <LeaveTypeInfo>[];
      json['info'].forEach((v) {
        info!.add(new LeaveTypeInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
