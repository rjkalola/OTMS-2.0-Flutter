class UserInfo {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? phone;
  String? extension;
  String? image;
  String? phoneWithExtension;
  String? userImage;
  String? userThumbImage;
  int? companyId;
  int? deviceType;
  String? apiToken;
  bool? isCheck;

  UserInfo(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.email,
      this.phone,
      this.extension,
      this.image,
      this.phoneWithExtension,
      this.userImage,
      this.userThumbImage,
      this.companyId,
      this.deviceType,
      this.apiToken,
      this.isCheck});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    extension = json['extension'];
    image = json['image'];
    phoneWithExtension = json['phone_with_extension'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    companyId = json['company_id'];
    deviceType = json['device_type'];
    apiToken = json['api_token'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['extension'] = this.extension;
    data['image'] = this.image;
    data['phone_with_extension'] = this.phoneWithExtension;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['company_id'] = this.companyId;
    data['device_type'] = this.deviceType;
    data['api_token'] = this.apiToken;
    data['isCheck'] = this.isCheck;
    return data;
  }

  UserInfo copyWith(
      {int? id,
      String? firstName,
      String? lastName,
      String? name,
      String? email,
      String? phone,
      String? extension,
      String? image,
      String? phoneWithExtension,
      String? userImage,
      String? userThumbImage,
      int? companyId,
      int? deviceType,
      String? deviceToken,
      bool? isCheck}) {
    return UserInfo(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        extension: extension ?? this.extension,
        image: image ?? this.image,
        phoneWithExtension: phoneWithExtension ?? this.phoneWithExtension,
        userImage: userImage ?? this.userImage,
        userThumbImage: userImage ?? this.userThumbImage,
        companyId: companyId ?? this.companyId,
        deviceType: deviceType ?? this.deviceType,
        apiToken: deviceToken ?? this.apiToken,
        isCheck: isCheck ?? this.isCheck);
  }
}
