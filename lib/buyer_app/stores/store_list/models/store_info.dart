class StoreInfo {
  int? id;
  String? name;
  int? companyId;
  String? companyName;
  String? email;
  String? street;
  String? location;
  String? town;
  String? postcode;
  String? phone;
  String? extension;
  String? address;
  String? phoneWithExtension;
  int? managerId;
  String? managerName;
  bool? status;
  int? productsCount;
  String? productIds;

  StoreInfo(
      {this.id,
        this.name,
        this.companyId,
        this.companyName,
        this.email,
        this.street,
        this.location,
        this.town,
        this.postcode,
        this.phone,
        this.extension,
        this.address,
        this.phoneWithExtension,
        this.managerId,
        this.managerName,
        this.status,
        this.productsCount,
        this.productIds});

  StoreInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    email = json['email'];
    street = json['street'];
    location = json['location'];
    town = json['town'];
    postcode = json['postcode'];
    phone = json['phone'];
    extension = json['extension'];
    address = json['address'];
    phoneWithExtension = json['phone_with_extension'];
    managerId = json['manager_id'];
    managerName = json['manager_name'];
    status = json['status'];
    productsCount = json['products_count'];
    productIds = json['product_ids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['email'] = this.email;
    data['street'] = this.street;
    data['location'] = this.location;
    data['town'] = this.town;
    data['postcode'] = this.postcode;
    data['phone'] = this.phone;
    data['extension'] = this.extension;
    data['address'] = this.address;
    data['phone_with_extension'] = this.phoneWithExtension;
    data['manager_id'] = this.managerId;
    data['manager_name'] = this.managerName;
    data['status'] = this.status;
    data['products_count'] = this.productsCount;
    data['product_ids'] = this.productIds;
    return data;
  }
}