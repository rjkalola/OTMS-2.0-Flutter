class WorkshopHiredToolsResponse {
  bool? isSuccess;
  String? message;
  int? all;
  int? requested;
  int? hired;
  int? activeCompanyId;
  List<WorkshopHiredToolInfo>? info;

  WorkshopHiredToolsResponse({
    this.isSuccess,
    this.message,
    this.all,
    this.requested,
    this.hired,
    this.activeCompanyId,
    this.info,
  });

  WorkshopHiredToolsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    all = json['all'];
    requested = json['requested'];
    hired = json['hired'];
    activeCompanyId = json['active_company_id'];
    if (json['info'] != null) {
      info = <WorkshopHiredToolInfo>[];
      for (final v in json['info'] as List) {
        info!.add(WorkshopHiredToolInfo.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}

class WorkshopHiredToolInfo {
  int? id;
  String? orderId;
  String? date;
  int? status;
  String? statusText;
  String? statusColor;
  String? userName;
  String? userImage;
  int? productId;
  String? uuid;
  String? shortName;
  String? name;
  String? imageUrl;
  String? thumbUrl;
  int? orderStatus;
  String? orderStatusText;
  String? orderStatusColor;
  int? orderBy;
  String? orderByUserName;
  int? approvedBy;
  String? approvedAt;
  int? rejectedBy;
  String? rejectedAt;
  int? returnBy;
  String? returnAt;

  WorkshopHiredToolInfo({
    this.id,
    this.orderId,
    this.date,
    this.status,
    this.statusText,
    this.statusColor,
    this.userName,
    this.userImage,
    this.productId,
    this.uuid,
    this.shortName,
    this.name,
    this.imageUrl,
    this.thumbUrl,
    this.orderStatus,
    this.orderStatusText,
    this.orderStatusColor,
    this.orderBy,
    this.orderByUserName,
    this.approvedBy,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedAt,
    this.returnBy,
    this.returnAt,
  });

  WorkshopHiredToolInfo.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    orderId = json['order_id']?.toString();
    date = json['date']?.toString();
    status = _toInt(json['status']);
    statusText = json['status_text']?.toString();
    statusColor = json['status_color']?.toString();
    userName = json['user_name']?.toString();
    userImage = json['user_image']?.toString();
    productId = _toInt(json['product_id']);
    uuid = json['uuid']?.toString();
    shortName = json['short_name']?.toString();
    name = json['name']?.toString();
    imageUrl = json['image_url']?.toString();
    thumbUrl = json['thumb_url']?.toString();
    orderStatus = _toInt(json['order_status']);
    orderStatusText = json['order_status_text']?.toString();
    orderStatusColor = json['order_status_color']?.toString();
    orderBy = _toInt(json['order_by']);
    orderByUserName = json['order_by_user_name']?.toString();
    approvedBy = _toInt(json['approved_by']);
    approvedAt = json['approved_at']?.toString();
    rejectedBy = _toInt(json['rejected_by']);
    rejectedAt = json['rejected_at']?.toString();
    returnBy = _toInt(json['return_by']);
    returnAt = json['return_at']?.toString();
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }
}
