class DigitalIdCardInfo {
  int? userId;
  int? companyId;
  String? companyName;
  String? firstName;
  String? lastName;
  String? name;
  String? tradeName;
  String? companyLogo;
  String? companyThumbLogo;
  String? userImage;
  String? userThumbImage;
  String? joinedOn;
  String? qrCodeUrl;
  bool? isExpired;
  String? webUrl;
  String? pdfDownloadUrl;

  DigitalIdCardInfo(
      {this.userId,
      this.companyId,
      this.companyName,
      this.firstName,
      this.lastName,
      this.name,
      this.tradeName,
      this.companyLogo,
      this.companyThumbLogo,
      this.userImage,
      this.userThumbImage,
      this.joinedOn,
      this.qrCodeUrl,
      this.isExpired,
      this.webUrl,
      this.pdfDownloadUrl});

  DigitalIdCardInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    tradeName = json['trade_name'];
    companyLogo = json['company_logo'];
    companyThumbLogo = json['company_thumb_logo'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    joinedOn = json['joined_on'];
    qrCodeUrl = json['qr_code_url'];
    isExpired = json['is_expired'];
    webUrl = json['web_url'];
    pdfDownloadUrl = json['pdf_download_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['trade_name'] = this.tradeName;
    data['company_logo'] = this.companyLogo;
    data['company_thumb_logo'] = this.companyThumbLogo;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['joined_on'] = this.joinedOn;
    data['qr_code_url'] = this.qrCodeUrl;
    data['is_expired'] = this.isExpired;
    data['web_url'] = this.webUrl;
    data['pdf_download_url'] = this.pdfDownloadUrl;
    return data;
  }
}
