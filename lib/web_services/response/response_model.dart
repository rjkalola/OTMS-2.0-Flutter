class ResponseModel {
  int? statusCode;
  String? statusMessage;
  String? messageCode;
  String? result;

  ResponseModel({
    this.statusCode,
    this.statusMessage,
    this.result
  });

  @override
  String toString() {
    return 'ResponseModel{statusCode: $statusCode, statusMessage: $statusMessage, messageCode: $messageCode, result: $result}';
  }
}