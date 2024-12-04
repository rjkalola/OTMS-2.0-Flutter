class BaseResponse {
  String? Message, ErrorCode;
  bool? IsSuccess;

  BaseResponse({this.IsSuccess, this.Message, this.ErrorCode});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    ErrorCode = json['ErrorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    data['ErrorCode'] = ErrorCode;
    return data;
  }
}

