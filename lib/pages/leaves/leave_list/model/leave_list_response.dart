import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';

class LeaveListResponse {
  bool? isSuccess;
  String? message;
  List<LeaveInfo>? data;

  LeaveListResponse({this.isSuccess, this.message, this.data});

  LeaveListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaveInfo>[];
      json['data'].forEach((v) {
        data!.add(new LeaveInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
