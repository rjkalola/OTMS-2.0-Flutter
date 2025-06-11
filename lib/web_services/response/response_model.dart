class ResponseModel {
  int? statusCode;
  String? statusMessage;
  String? messageCode;
  String? result;
  bool isSuccess;

  ResponseModel(
      {required this.isSuccess,
      this.statusCode,
      this.statusMessage,
      this.result});

  @override
  String toString() {
    return 'ResponseModel{statusCode: $statusCode, statusMessage: $statusMessage, messageCode: $messageCode, result: $result}';
  }
}
