class UserInfo {
  int? id;
  String? firstName;
  String? lastName;
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

  UserInfo(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.extension,
      this.image,
      this.phoneWithExtension,
      this.userImage,
      this.userThumbImage,
      this.companyId,
      this.deviceType,
      this.apiToken});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
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

    return data;
  }

  UserInfo copyWith({
    int? id,
    String? firstName,
    String? lastName,
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
  }) {
    return UserInfo(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
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
    );
  }
}
