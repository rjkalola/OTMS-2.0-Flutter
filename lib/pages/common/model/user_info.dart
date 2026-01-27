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
  int? tradeId;
  String? tradeName;
  bool? isCheck;
  int? userRoleId;
  bool? isWorking;
  bool? showRate;
  bool? isTradeAvailable;
  String? userCode;

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
      this.tradeId,
      this.tradeName,
      this.isCheck,
      this.userRoleId,
      this.isWorking,
      this.showRate,
      this.isTradeAvailable,
      this.userCode});

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
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    isCheck = json['isCheck'];
    userRoleId = json['user_role_id'];
    isWorking = json['is_working'];
    showRate = json['show_rate'];
    isTradeAvailable = json['is_trade_available'];
    userCode = json['user_code'];
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
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['isCheck'] = this.isCheck;
    data['user_role_id'] = this.userRoleId;
    data['is_working'] = this.isWorking;
    data['show_rate'] = this.showRate;
    data['is_trade_available'] = this.isTradeAvailable;
    data['user_code'] = this.userCode;
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
      bool? isCheck,
      int? userRoleId,
      bool? isWorking,
      bool? showRate,
      bool? isTradeAvailable,
      String? userCode}) {
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
        tradeId: tradeId ?? this.tradeId,
        tradeName: tradeName ?? this.tradeName,
        isCheck: isCheck ?? this.isCheck,
        userRoleId: userRoleId ?? this.userRoleId,
        isWorking: isWorking ?? this.isWorking,
        showRate: showRate ?? this.showRate,
        isTradeAvailable: isTradeAvailable ?? this.isTradeAvailable,
        userCode: userCode ?? this.userCode);
  }

  UserInfo copyUserInfo({UserInfo? userInfo}) {
    return UserInfo(
        id: userInfo?.id ?? this.id,
        firstName: userInfo?.firstName ?? this.firstName,
        lastName: userInfo?.lastName ?? this.lastName,
        name: userInfo?.name ?? this.name,
        email: userInfo?.email ?? this.email,
        phone: userInfo?.phone ?? this.phone,
        extension: userInfo?.extension ?? this.extension,
        image: userInfo?.image ?? this.image,
        phoneWithExtension:
            userInfo?.phoneWithExtension ?? this.phoneWithExtension,
        userImage: userInfo?.userImage ?? this.userImage,
        userThumbImage: userInfo?.userImage ?? this.userThumbImage,
        companyId: userInfo?.companyId ?? this.companyId,
        deviceType: userInfo?.deviceType ?? this.deviceType,
        apiToken: userInfo?.apiToken ?? this.apiToken,
        tradeId: userInfo?.tradeId ?? this.tradeId,
        tradeName: userInfo?.tradeName ?? this.tradeName,
        isCheck: userInfo?.isCheck ?? this.isCheck,
        userRoleId: userInfo?.userRoleId ?? this.userRoleId,
        isWorking: userInfo?.isWorking ?? this.isWorking,
        showRate: userInfo?.showRate ?? this.showRate,
        isTradeAvailable: userInfo?.isTradeAvailable ?? this.isTradeAvailable,
        userCode: userInfo?.userCode ?? this.userCode);
  }
}
