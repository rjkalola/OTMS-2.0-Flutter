class InvoiceInfo {
  int? id;
  int? companyId;
  String? companyName;
  String? image;
  String? thumbImage;
  String? pdf;
  String? invoiceNumber;
  String? description;
  String? fromDate;
  String? toDate;
  String? invoiceDate;
  bool? fromAdmin;
  bool? fromBookkeeper;
  String? date;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  bool? isWorking;
  bool? isCheck;

  InvoiceInfo(
      {this.id,
      this.companyId,
      this.companyName,
      this.image,
      this.thumbImage,
      this.pdf,
      this.invoiceNumber,
      this.description,
      this.fromDate,
      this.toDate,
      this.invoiceDate,
      this.fromAdmin,
      this.fromBookkeeper,
      this.date,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.isWorking,
      this.isCheck});

  InvoiceInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    image = json['image'];
    thumbImage = json['thumb_image'];
    pdf = json['pdf'];
    invoiceNumber = json['invoice_number'];
    description = json['description'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    invoiceDate = json['invoice_date'];
    fromAdmin = json['from_admin'];
    fromBookkeeper = json['from_bookkeeper'];
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
    data['invoice_number'] = this.invoiceNumber;
    data['description'] = this.description;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['invoice_date'] = this.invoiceDate;
    data['from_admin'] = this.fromAdmin;
    data['from_bookkeeper'] = this.fromBookkeeper;
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
