class PenaltyInfo {
  int? id;
  String? startTime;
  String? endTime;
  int? payableSeconds;
  String? penaltyType;
  int? penaltySeconds;
  String? penaltyAmount;

  int? status;
  int? appealStatus;
  int? penaltyId;
  int? appealId;
  String? appealNote;
  String? adminNote;

  PenaltyInfo({
    this.id,
    this.startTime,
    this.endTime,
    this.payableSeconds,
    this.penaltyType,
    this.penaltySeconds,
    this.penaltyAmount,
    this.status,
    this.appealStatus,
    this.penaltyId,
    this.appealId,
    this.appealNote,
    this.adminNote,
  });

  PenaltyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    payableSeconds = json['payable_seconds'];
    penaltyType = json['penalty_type'];
    penaltySeconds = json['penalty_seconds'];
    penaltyAmount = json['penalty_amount'];
    status = json['status'];
    appealStatus = json['appeal_status'];
    penaltyId = json['penalty_id'];
    appealId = json['appeal_id'];
    appealNote = json['appeal_note'];
    adminNote = json['admin_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['payable_seconds'] = payableSeconds;
    data['penalty_type'] = penaltyType;
    data['penalty_seconds'] = penaltySeconds;
    data['penalty_amount'] = penaltyAmount;
    data['status'] = status;
    data['appeal_status'] = appealStatus;
    data['penalty_id'] = penaltyId;
    data['appeal_id'] = appealId;
    data['appeal_note'] = appealNote;
    data['admin_note'] = adminNote;

    return data;
  }
}
