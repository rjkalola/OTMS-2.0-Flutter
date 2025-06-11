class BaseResponse {
  String? Message, statusCode;
  bool? IsSuccess;

  BaseResponse({this.IsSuccess, this.Message, this.statusCode});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['message'] = Message;
    data['statusCode'] = statusCode;
    return data;
  }
}

