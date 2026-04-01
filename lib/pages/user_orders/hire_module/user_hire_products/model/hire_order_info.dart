import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class HireOrderInfo {
  int? id;
  int? companyId;
  String? companyName;
  String? companyImage;
  String? orderId;
  String? date;
  String? fromDate;
  String? toDate;
  String? fromDateFormate;
  String? toDateFormate;
  String? fullDate;
  int? status;
  String? statusText;
  String? statusColor;
  String? approvedBy;
  String? userName;
  String? userImage;
  int? projectId;
  String? projectName;
  int? addressId;
  String? addressName;
  List<ProductInfo>? products;

  HireOrderInfo({
    this.id,
    this.companyId,
    this.companyName,
    this.companyImage,
    this.orderId,
    this.date,
    this.fromDate,
    this.toDate,
    this.fromDateFormate,
    this.toDateFormate,
    this.fullDate,
    this.status,
    this.statusText,
    this.statusColor,
    this.approvedBy,
    this.userName,
    this.userImage,
    this.projectId,
    this.projectName,
    this.addressId,
    this.addressName,
    this.products,
  });

  HireOrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyImage = json['company_image'];
    orderId = json['order_id']?.toString();
    date = json['date'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    fromDateFormate = json['from_date_formate'];
    toDateFormate = json['to_date_formate'];
    fullDate = json['full_date'];
    status = json['status'];
    statusText = json['status_text'];
    statusColor = json['status_color'];
    approvedBy =
        json['approved_by'] == null ? null : json['approved_by'].toString();
    userName = json['user_name'];
    userImage = json['user_image'];
    projectId = json['project_id'] is int
        ? json['project_id'] as int
        : int.tryParse(json['project_id']?.toString() ?? '');
    projectName = json['project_name']?.toString() ??
        json['project_title']?.toString();
    addressId = json['address_id'] is int
        ? json['address_id'] as int
        : int.tryParse(json['address_id']?.toString() ?? '');
    addressName = json['address_name']?.toString() ??
        json['site_address']?.toString();
    if (json['products'] != null) {
      products = <ProductInfo>[];
      for (final v in json['products'] as List) {
        products!
            .add(ProductInfo.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}

