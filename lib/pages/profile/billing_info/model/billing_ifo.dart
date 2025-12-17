
import 'dart:ffi';

class BillingInfo {
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
  String? net_rate_perDay;
  String? currency;
  int? tradeId;
  String? tradeName;
  String? joiningDate;
  String? companyName;
  bool? is_rate_requested;
  String? oldNetRatePerDay;
  String? newNetRatePerDay;
  String? oldTrade;
  String? newTrade;

  BillingInfo(
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
      this.statusText,
      this.currency,
      this.joiningDate,
      this.net_rate_perDay,
      this.tradeName,
      this.tradeId,
      this.companyName,
      this.is_rate_requested,
      this.newNetRatePerDay,
      this.oldNetRatePerDay,
      this.oldTrade,
      this.newTrade});

  BillingInfo.fromJson(Map<String, dynamic> json) {
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
    net_rate_perDay = json['net_rate_perDay'].toString();
    currency = json['currency'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    joiningDate = json['joining_date'];
    companyName = json['company_name'];
    is_rate_requested = json['is_rate_requested'];
    newNetRatePerDay = json['new_net_rate_perday'].toString();
    oldNetRatePerDay = json['old_net_rate_perday'].toString();
    oldTrade = json['old_trade'];
    newTrade = json['new_trade'];
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
    data['net_rate_perDay'] = this.net_rate_perDay;
    data['currency'] = this.currency;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['joining_date'] = this.joiningDate;
    data['company_name'] = this.companyName;
    data['is_rate_requested'] = this.is_rate_requested;
    data['new_net_rate_perday'] = this.newNetRatePerDay;
    data['old_net_rate_perday'] = this.oldNetRatePerDay;
    data['old_trade'] = this.oldTrade;
    data['new_trade'] = this.newTrade;
    return data;
  }
}
