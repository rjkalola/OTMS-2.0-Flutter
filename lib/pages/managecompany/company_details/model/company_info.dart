class CompanyInfo {
  int? id;
  String? name;
  String? phone;
  String? extension;
  String? phoneWithExtension;
  String? email;
  String? createdBy;
  int? createdByInt;
  String? companyImage;
  String? companyThumbImage;

  CompanyInfo(
      {this.id,
      this.name,
      this.phone,
      this.extension,
      this.phoneWithExtension,
      this.email,
      this.createdBy,
      this.createdByInt,
      this.companyImage,
      this.companyThumbImage});

  CompanyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    extension = json['extension'];
    phoneWithExtension = json['phone_with_extension'];
    email = json['email'];
    createdBy = json['created_by'];
    createdByInt = json['created_by_int'];
    companyImage = json['company_image'];
    companyThumbImage = json['company_thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['extension'] = this.extension;
    data['phone_with_extension'] = this.phoneWithExtension;
    data['email'] = this.email;
    data['created_by'] = this.createdBy;
    data['created_by_int'] = this.createdByInt;
    data['company_image'] = this.companyImage;
    data['company_thumb_image'] = this.companyThumbImage;
    return data;
  }
}
