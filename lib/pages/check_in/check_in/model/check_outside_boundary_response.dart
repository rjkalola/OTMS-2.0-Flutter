

class CheckOutsideBoundaryResponse {
  bool? isSuccess;
  String? message;
  bool? outSideBoundary;

  CheckOutsideBoundaryResponse(
      {this.isSuccess,
      this.message,
      this.outSideBoundary});

  CheckOutsideBoundaryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    outSideBoundary = json['outside_boundary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['outside_boundary'] = this.outSideBoundary;
    return data;
  }
}
