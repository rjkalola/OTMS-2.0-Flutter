import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';

class LeaveDetailsResponse {
  bool? isSuccess;
  String? message;
  LeaveInfo? data;

  LeaveDetailsResponse({this.isSuccess, this.message, this.data});

  LeaveDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    data = json['data'] != null ? new LeaveInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
