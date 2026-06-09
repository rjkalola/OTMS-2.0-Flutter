class StockHistoryResponse {
  bool? isSuccess;
  String? message;
  List<StockHistoryInfo>? info;
  int? total;
  int? activeCompanyId;

  StockHistoryResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.total,
    this.activeCompanyId,
  });

  factory StockHistoryResponse.fromJson(Map<String, dynamic> json) {
    return StockHistoryResponse(
      isSuccess: json['IsSuccess'],
      message: json['message'],
      info: json['info'] != null
          ? (json['info'] as List)
              .map((e) => StockHistoryInfo.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      total: _parseInt(json['total']),
      activeCompanyId: _parseInt(json['active_company_id']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class StockHistoryInfo {
  int? id;
  int? companyId;
  String? companyName;
  String? date;
  String? name;
  String? uuid;
  String? currency;
  num? price;
  int? userId;
  String? userName;
  String? userImage;
  int? actionBy;
  String? actionByName;
  String? actionByImage;
  String? note;
  bool? isSubQty;
  String? packOffQty;
  String? packOffName;
  int? packOffUnitId;
  dynamic qty;
  String? newQty;
  num? totalAmount;

  StockHistoryInfo({
    this.id,
    this.companyId,
    this.companyName,
    this.date,
    this.name,
    this.uuid,
    this.currency,
    this.price,
    this.userId,
    this.userName,
    this.userImage,
    this.actionBy,
    this.actionByName,
    this.actionByImage,
    this.note,
    this.isSubQty,
    this.packOffQty,
    this.packOffName,
    this.packOffUnitId,
    this.qty,
    this.newQty,
    this.totalAmount,
  });

  factory StockHistoryInfo.fromJson(Map<String, dynamic> json) {
    return StockHistoryInfo(
      id: json['id'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      date: json['date'],
      name: json['name'],
      uuid: json['uuid'],
      currency: json['currency'],
      price: json['price'],
      userId: json['user_id'],
      userName: json['user_name'],
      userImage: json['user_image'],
      actionBy: json['action_by'],
      actionByName: json['action_by_name'],
      actionByImage: json['action_by_image'],
      note: json['note'],
      isSubQty: json['is_sub_qty'],
      packOffQty: json['pack_off_qty']?.toString(),
      packOffName: json['pack_off_name'],
      packOffUnitId: json['pack_off_unit_id'],
      qty: json['qty'],
      newQty: json['new_qty']?.toString(),
      totalAmount: json['total_amount'],
    );
  }

  double get qtyValue {
    if (qty == null) return 0;
    if (qty is num) return qty.toDouble();
    final value = qty.toString().trim().replaceAll('+', '');
    if (value.isEmpty) return 0;
    return double.tryParse(value) ?? 0;
  }

  bool get isInMovement => qtyValue > 0;

  bool get isOutMovement => qtyValue < 0;

  String get displayDate {
    if (date == null || date!.isEmpty) return '';
    final parts = date!.split(' ');
    if (parts.length >= 2) {
      final datePart = parts.first;
      final shortDate =
          datePart.length >= 5 ? datePart.substring(0, 5) : datePart;
      return '$shortDate ${parts[1]}';
    }
    return date!;
  }

  String get centerLabel {
    if (note != null && note!.trim().isNotEmpty) return note!.trim();
    if (userName != null && userName!.trim().isNotEmpty) {
      return userName!.trim();
    }
    return '';
  }

  bool get hasNote => note != null && note!.trim().isNotEmpty;
}
