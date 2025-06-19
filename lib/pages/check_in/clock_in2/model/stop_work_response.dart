class StopWorkResponse {
  bool? isSuccess;
  String? message;
  int? id;
  String? shiftName;
  String? workStartTime;
  String? workStopTime;
  String? note;
  int? supervisorId;
  int? teamId;
  int? tradeId;
  bool? addExpenseBtn;
  String? amount;

  StopWorkResponse(
      {this.isSuccess,
      this.message,
      this.id,
      this.shiftName,
      this.workStartTime,
      this.workStopTime,
      this.note,
      this.supervisorId,
      this.teamId,
      this.tradeId,
      this.addExpenseBtn,
      this.amount});

  StopWorkResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    id = json['id'];
    shiftName = json['shift_name'];
    workStartTime = json['work_start_time'];
    workStopTime = json['work_stop_time'];
    note = json['note'];
    supervisorId = json['supervisor_id'];
    teamId = json['team_id'];
    tradeId = json['trade_id'];
    addExpenseBtn = json['add_expense_btn'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['id'] = this.id;
    data['shift_name'] = this.shiftName;
    data['work_start_time'] = this.workStartTime;
    data['work_stop_time'] = this.workStopTime;
    data['note'] = this.note;
    data['supervisor_id'] = this.supervisorId;
    data['team_id'] = this.teamId;
    data['trade_id'] = this.tradeId;
    data['add_expense_btn'] = this.addExpenseBtn;
    data['amount'] = this.amount;
    return data;
  }
}
