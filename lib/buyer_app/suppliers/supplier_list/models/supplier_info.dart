class SupplierInfo {
  int? id;
  String? name;
  int? companyId;
  String? companyName;
  String? imageUrl;
  String? thumbUrl;
  String? email;
  String? accountNumber;
  String? street;
  String? location;
  String? town;
  String? postcode;
  String? phone;
  String? extension;
  String? phoneWithExtension;
  bool? status;
  String? contactPersonEmail;
  String? contactPersonName;
  String? contactPersonPhone;
  String? contactPersonExtension;

  SupplierInfo(
      {this.id,
        this.name,
        this.companyId,
        this.companyName,
        this.imageUrl,
        this.thumbUrl,
        this.email,
        this.accountNumber,
        this.street,
        this.location,
        this.town,
        this.postcode,
        this.phone,
        this.extension,
        this.phoneWithExtension,
        this.status,
        this.contactPersonEmail,
        this.contactPersonName,
        this.contactPersonPhone,
        this.contactPersonExtension});

  SupplierInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    email = json['email'];
    accountNumber = json['account_number'];
    street = json['street'];
    location = json['location'];
    town = json['town'];
    postcode = json['postcode'];
    phone = json['phone'];
    extension = json['extension'];
    phoneWithExtension = json['phone_with_extension'];
    status = json['status'];
    contactPersonEmail = json['contact_person_email'];
    contactPersonName = json['contact_person_name'];
    contactPersonPhone = json['contact_person_phone'];
    contactPersonExtension = json['contact_person_extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    data['email'] = this.email;
    data['account_number'] = this.accountNumber;
    data['street'] = this.street;
    data['location'] = this.location;
    data['town'] = this.town;
    data['postcode'] = this.postcode;
    data['phone'] = this.phone;
    data['extension'] = this.extension;
    data['phone_with_extension'] = this.phoneWithExtension;
    data['status'] = this.status;
    data['contact_person_email'] = this.contactPersonEmail;
    data['contact_person_name'] = this.contactPersonName;
    data['contact_person_phone'] = this.contactPersonPhone;
    data['contact_person_extension'] = this.contactPersonExtension;
    return data;
  }
}