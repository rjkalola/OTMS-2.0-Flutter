class BillingRequestInfo {
  int? id;
  int? userId;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? postCode;
  String? address;
  String? extension;
  String? phone;
  String? nameOnUtr;
  String? utrNumber;
  String? ninNumber;
  String? nameOnAccount;
  String? bankName;
  String? accountNo;
  String? shortCode;
  String? userImage;
  String? userThumbImage;
  int? companyId;
  int? status;
  String? statusText;

  BillingRequestInfo(
      {this.id,
        this.userId,
        this.name,
        this.firstName,
        this.middleName,
        this.lastName,
        this.email,
        this.postCode,
        this.address,
        this.extension,
        this.phone,
        this.nameOnUtr,
        this.utrNumber,
        this.ninNumber,
        this.nameOnAccount,
        this.bankName,
        this.accountNo,
        this.shortCode,
        this.userImage,
        this.userThumbImage,
        this.companyId,
        this.status,
        this.statusText});

  BillingRequestInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    name = json['name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    email = json['email'];
    postCode = json['post_code'];
    address = json['address'];
    extension = json['extension'];
    phone = json['phone'];
    nameOnUtr = json['name_on_utr'];
    utrNumber = json['utr_number'];
    ninNumber = json['nin_number'];
    nameOnAccount = json['name_on_account'];
    bankName = json['bank_name'];
    accountNo = json['account_no'];
    shortCode = json['short_code'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    status = json['status'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['post_code'] = this.postCode;
    data['address'] = this.address;
    data['extension'] = this.extension;
    data['phone'] = this.phone;
    data['name_on_utr'] = this.nameOnUtr;
    data['utr_number'] = this.utrNumber;
    data['nin_number'] = this.ninNumber;
    data['name_on_account'] = this.nameOnAccount;
    data['bank_name'] = this.bankName;
    data['account_no'] = this.accountNo;
    data['short_code'] = this.shortCode;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    return data;
  }
}