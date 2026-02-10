class PayslipInfo {
  int? id;
  int? companyId;
  String? companyName;
  String? image;
  String? thumbImage;
  String? pdf;
  String? payslipNumber;
  String? fromDate;
  String? toDate;
  String? paymentDate;
  String? date;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  bool? isWorking;
  bool? isCheck;

  PayslipInfo(
      {this.id,
      this.companyId,
      this.companyName,
      this.image,
      this.thumbImage,
      this.pdf,
      this.payslipNumber,
      this.fromDate,
      this.toDate,
      this.paymentDate,
      this.date,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.isWorking,
      this.isCheck});

  PayslipInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    image = json['image'];
    thumbImage = json['thumb_image'];
    pdf = json['pdf'];
    payslipNumber = json['payslip_number'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    paymentDate = json['payment_date'];
    date = json['date'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    isWorking = json['is_working'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['image'] = this.image;
    data['thumb_image'] = this.thumbImage;
    data['pdf'] = this.pdf;
    data['payslip_number'] = this.payslipNumber;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['payment_date'] = this.paymentDate;
    data['date'] = this.date;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['is_working'] = this.isWorking;
    data['isCheck'] = this.isCheck;
    return data;
  }
}
