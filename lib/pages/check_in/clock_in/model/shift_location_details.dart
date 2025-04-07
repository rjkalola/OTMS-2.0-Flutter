class ShiftLocationDetails {
  int? id;
  int? shiftDetailId;
  String? time;
  String? extraTime;
  String? extraMin;
  String? penaltyTime;
  String? penaltyMin;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  bool? status;

  ShiftLocationDetails(
      {this.id,
      this.shiftDetailId,
      this.time,
      this.extraTime,
      this.extraMin,
      this.penaltyTime,
      this.penaltyMin,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.status});

  ShiftLocationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftDetailId = json['shift_detail_id'];
    time = json['time'];
    extraTime = json['extra_time'];
    extraMin = json['extra_min'];
    penaltyTime = json['penalty_time'];
    penaltyMin = json['penalty_min'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_detail_id'] = this.shiftDetailId;
    data['time'] = this.time;
    data['extra_time'] = this.extraTime;
    data['extra_min'] = this.extraMin;
    data['penalty_time'] = this.penaltyTime;
    data['penalty_min'] = this.penaltyMin;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}
