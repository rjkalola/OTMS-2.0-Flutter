class AdjustmentInfo {
  String? type;
  int? id;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  int? addedBy;
  String? addedByUserName;
  String? addedByUserImage;
  String? addedByUserThumbImage;
  String? currency;
  String? receiptDate;
  String? dateAdded;
  int? adjustmentId;
  double? adjustedAmount;
  double? totalAmount;

  // int? cisAmount;
  // int? grossAmount;
  int? status;
  String? note;
  String? createdAt;

  AdjustmentInfo(
      {this.type,
      this.id,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.addedBy,
      this.addedByUserName,
      this.addedByUserImage,
      this.addedByUserThumbImage,
      this.currency,
      this.receiptDate,
      this.dateAdded,
      this.adjustmentId,
      this.adjustedAmount,
      this.totalAmount,
      // this.cisAmount,
      // this.grossAmount,
      this.status,
      this.note,
      this.createdAt});

  AdjustmentInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    addedBy = json['added_by'];
    addedByUserName = json['added_by_user_name'];
    addedByUserImage = json['added_by_user_image'];
    addedByUserThumbImage = json['added_by_user_thumb_image'];
    currency = json['currency'];
    receiptDate = json['receipt_date'];
    dateAdded = json['date_added'];
    adjustmentId = json['adjustment_id'];
    adjustedAmount = (json['adjusted_amount'] as num?)?.toDouble();
    totalAmount = (json['total_amount'] as num?)?.toDouble();
    // cisAmount = json['cis_amount'];
    // grossAmount = json['gross_amount'];
    status = json['status'];
    note = json['note'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['added_by'] = this.addedBy;
    data['added_by_user_name'] = this.addedByUserName;
    data['added_by_user_image'] = this.addedByUserImage;
    data['added_by_user_thumb_image'] = this.addedByUserThumbImage;
    data['currency'] = this.currency;
    data['receipt_date'] = this.receiptDate;
    data['date_added'] = this.dateAdded;
    data['adjustment_id'] = this.adjustmentId;
    data['adjusted_amount'] = this.adjustedAmount;
    data['total_amount'] = this.totalAmount;
    // data['cis_amount'] = this.cisAmount;
    // data['gross_amount'] = this.grossAmount;
    data['status'] = this.status;
    data['note'] = this.note;
    data['created_at'] = this.createdAt;
    return data;
  }
}
