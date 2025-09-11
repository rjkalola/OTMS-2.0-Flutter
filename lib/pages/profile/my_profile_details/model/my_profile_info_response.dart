class MyProfileInfoResponse {
  bool? isSuccess;
  String? message;
  MyProfileInfo? info;

  MyProfileInfoResponse({this.isSuccess, this.message, this.info});

  MyProfileInfoResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new MyProfileInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class MyProfileInfo{
  int? id;
  String? email;
  String? extension;
  String? phone;
  String? phoneWithExtension;
  String? userName;
  String? userImage;
  String? userThumbImage;
  int? tradeId;
  String? tradeName;
  bool? isWorking;

  MyProfileInfo(
      {this.id,
        this.email,
        this.extension,
        this.phone,
        this.phoneWithExtension,
        this.userName,
        this.userImage,
        this.userThumbImage,
        this.tradeId,
        this.tradeName,
        this.isWorking});

  MyProfileInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    extension = json['extension'];
    phone = json['phone'];
    phoneWithExtension = json['phone_with_extension'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    isWorking = json['is_working'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['extension'] = this.extension;
    data['phone'] = this.phone;
    data['phone_with_extension'] = this.phoneWithExtension;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['is_working'] = this.isWorking;
    return data;
  }
}