import 'dart:convert';

import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/project/project_info/model/geofence_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/break_info.dart';

class PenaltyInfo {
  int? id;
  String? startTime;
  String? endTime;
  int? payableSeconds;
  String? penaltyType;
  int? penaltySeconds;
  String? penaltyAmount;
  int? status;
  int? penaltyId;

  PenaltyInfo(
      {this.id,
      this.startTime,
      this.endTime,
      this.payableSeconds,
      this.penaltyType,
      this.penaltySeconds,
      this.penaltyAmount,
      this.status,
      this.penaltyId});

  PenaltyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    payableSeconds = json['payable_seconds'];
    penaltyType = json['penalty_type'];
    penaltySeconds = json['penalty_seconds'];
    penaltyAmount = json['penalty_amount'];
    status = json['status'];
    penaltyId = json['penalty_id'];
    // status = int.tryParse(json['status']?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['payable_seconds'] = this.payableSeconds;
    data['penalty_type'] = this.penaltyType;
    data['penalty_seconds'] = this.penaltySeconds;
    data['penalty_amount'] = this.penaltyAmount;
    data['status'] = this.status;
    data['penalty_id'] = this.penaltyId;
    return data;
  }
}
