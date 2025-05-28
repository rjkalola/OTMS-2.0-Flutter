class CompanyInfo {
  int? id;
  String? createdBy;
  int? businessId;
  int? teamSizeId;
  String? name;
  String? email;
  String? code;
  String? phone;
  String? extension;
  String? phoneWithExtension;
  String? image;
  String? address;
  String? website;
  String? description;
  String? registrationNumber;
  String? vatNumber;
  String? establishedDate;
  String? mainContracts;
  String? workingHour;
  String? insuranceNumber;
  String? insuranceExpiresOn;
  String? totalTeamUsers;
  String? teamOperation;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? createdByInt;
  String? companyImage;
  String? companyThumbImage;

  CompanyInfo(
      {this.id,
      this.createdBy,
      this.businessId,
      this.teamSizeId,
      this.name,
      this.email,
      this.code,
      this.phone,
      this.extension,
      this.phoneWithExtension,
      this.image,
      this.address,
      this.website,
      this.description,
      this.registrationNumber,
      this.vatNumber,
      this.establishedDate,
      this.mainContracts,
      this.workingHour,
      this.insuranceNumber,
      this.insuranceExpiresOn,
      this.totalTeamUsers,
      this.teamOperation,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdByInt,
      this.companyImage,
      this.companyThumbImage});

  CompanyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    businessId = json['business_id'];
    teamSizeId = json['team_size_id'];
    name = json['name'];
    email = json['email'];
    code = json['code'];
    phone = json['phone'];
    extension = json['extension'];
    phoneWithExtension = json['phone_with_extension'];
    image = json['image'];
    address = json['address'];
    website = json['website'];
    description = json['description'];
    registrationNumber = json['registration_number'];
    vatNumber = json['vat_number'];
    establishedDate = json['established_date'];
    mainContracts = json['main_contracts'];
    workingHour = json['working_hour'];
    insuranceNumber = json['insurance_number'];
    insuranceExpiresOn = json['insurance_expires_on'];
    totalTeamUsers = json['total_team_users'];
    teamOperation = json['team_operation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    createdByInt = json['created_by_int'];
    companyImage = json['company_image'];
    companyThumbImage = json['company_thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['business_id'] = this.businessId;
    data['team_size_id'] = this.teamSizeId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['code'] = this.code;
    data['phone'] = this.phone;
    data['extension'] = this.extension;
    data['phone_with_extension'] = this.phoneWithExtension;
    data['image'] = this.image;
    data['address'] = this.address;
    data['website'] = this.website;
    data['description'] = this.description;
    data['registration_number'] = this.registrationNumber;
    data['vat_number'] = this.vatNumber;
    data['established_date'] = this.establishedDate;
    data['main_contracts'] = this.mainContracts;
    data['working_hour'] = this.workingHour;
    data['insurance_number'] = this.insuranceNumber;
    data['insurance_expires_on'] = this.insuranceExpiresOn;
    data['total_team_users'] = this.totalTeamUsers;
    data['team_operation'] = this.teamOperation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_by_int'] = this.createdByInt;
    data['company_image'] = this.companyImage;
    data['company_thumb_image'] = this.companyThumbImage;
    return data;
  }
}
