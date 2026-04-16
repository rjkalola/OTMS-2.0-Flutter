import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';

class LeaveListResponse {
  bool? isSuccess;
  String? message;
  int? totalLeaves;
  List<LeaveInfo>? data;

  LeaveListResponse({this.isSuccess, this.message, this.totalLeaves, this.data});

  LeaveListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    totalLeaves = json['total_leaves'];
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
    data['total_leaves'] = this.totalLeaves;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
