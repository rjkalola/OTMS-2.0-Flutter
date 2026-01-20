class CheckLogSummeryInfo {
  int? id;
  String? checkinDate;
  String? startTime;
  String? endTime;
  int? payableSeconds;
  String? totalMinutes;
  String? checkInNote;
  String? checkOutNote;
  // String? progress;
  // String? status;

  CheckLogSummeryInfo(
      {this.id,
      this.checkinDate,
      this.startTime,
      this.endTime,
      this.payableSeconds,
      this.totalMinutes,
      this.checkInNote,
      this.checkOutNote,
      // this.progress,
      // this.status
      });

  CheckLogSummeryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkinDate = json['checkin_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    payableSeconds = json['payable_seconds'];
    totalMinutes = json['total_minutes'];
    checkInNote = json['checkin_note'];
    checkOutNote = json['checkout_note'];
    // progress = json['progress'];
    // status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['checkin_date'] = this.checkinDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['payable_seconds'] = this.payableSeconds;
    data['total_minutes'] = this.totalMinutes;
    data['checkin_note'] = this.checkInNote;
    data['checkout_note'] = this.checkOutNote;
    // data['progress'] = this.progress;
    // data['status'] = this.status;
    return data;
  }
}
