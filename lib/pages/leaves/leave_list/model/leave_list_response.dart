import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';

class LeaveListResponse {
  bool? isSuccess;
  String? message;
  String? totalLeaves;
  int? totalLeavesRaw;
  List<LeaveInfo>? data;

  LeaveListResponse(
      {this.isSuccess, this.message, this.totalLeaves, this.totalLeavesRaw, this.data});

  LeaveListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['total_leaves'] != null) {
      totalLeaves = json['total_leaves'].toString();
    }
    if (json['total_leaves_raw'] != null) {
      final raw = json['total_leaves_raw'];
      totalLeavesRaw = raw is int ? raw : (raw as num).toInt();
    }
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
    data['total_leaves_raw'] = this.totalLeavesRaw;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
