class PaymentsInfo{
  int? id;
  int? companyId;
  String? companyName;
  String? currency;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? weekRange;
  String? startDate;
  String? endDate;
  String? netTimeclockAmount;
  String? netExpenseAmount;
  String? totalPayableAmount;
  String? netPriceworkAmount;
  String? netPaidLeaveAmount;
  String? netAdjustmentAmount;
  String? netPenaltyAmount;
  String? cisAmount;
  String? grossAmount;

  PaymentsInfo(
      {this.id,
      this.companyId,
      this.companyName,
      this.currency,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.weekRange,
      this.startDate,
      this.endDate,
      this.netTimeclockAmount,
      this.netExpenseAmount,
      this.totalPayableAmount,
      this.netPriceworkAmount,
      this.netPaidLeaveAmount,
      this.netAdjustmentAmount,
      this.netPenaltyAmount,
      this.cisAmount,
      this.grossAmount});

  PaymentsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    currency = json['currency'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    weekRange = json['week_range'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    netTimeclockAmount = json['net_timeclock_amount'];
    netExpenseAmount = json['net_expense_amount'];
    totalPayableAmount = json['total_payable_amount'];
    netPriceworkAmount = json['net_pricework_amount'];
    netPaidLeaveAmount = json['net_paid_leave_amount'];
    netAdjustmentAmount = json['net_adjustment_amount'];
    netPenaltyAmount = json['net_penalty_amount'];
    cisAmount = json['cis_amount'];
    grossAmount = json['gross_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['currency'] = this.currency;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['week_range'] = this.weekRange;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['net_timeclock_amount'] = this.netTimeclockAmount;
    data['net_expense_amount'] = this.netExpenseAmount;
    data['total_payable_amount'] = this.totalPayableAmount;
    data['net_pricework_amount'] = this.netPriceworkAmount;
    data['net_paid_leave_amount'] = this.netPaidLeaveAmount;
    data['net_adjustment_amount'] = this.netAdjustmentAmount;
    data['net_penalty_amount'] = this.netPenaltyAmount;
    data['cis_amount'] = this.cisAmount;
    data['gross_amount'] = this.grossAmount;
    return data;
  }
}
