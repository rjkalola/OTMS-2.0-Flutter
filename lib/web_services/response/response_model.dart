class ResponseModel {
  int? statusCode;
  String? statusMessage;
  String? messageCode;
  String? result;
  bool? canAccessInventory;
  bool isSuccess;

  ResponseModel(
      {required this.isSuccess,
      this.statusCode,
      this.statusMessage,
      this.result,
      this.canAccessInventory});

  @override
  String toString() {
    return 'ResponseModel{statusCode: $statusCode, statusMessage: $statusMessage, messageCode: $messageCode, result: $result}';
  }
}
