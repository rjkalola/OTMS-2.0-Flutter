class ProductSetDataInfo {
  final int setId;
  final String setName;
  final int id;
  final int productId;
  final String name;
  final String shortName;
  final int companyId;
  final String companyName;
  final String currency;
  final String price;
  final String marketPrice;
  final String totalAmount;
  final int qty;
  final int subQty;
  final bool isSubQty;
  final String packOffQty;
  final int? packOffUnitId;
  final String? packOffUnit;
  final String stockStatus;
  final int stockStatusId;
  final String statusColor;
  final int supplierId;
  final String supplierName;
  final String supplierCode;
  final int cartQty;
  final int? cartId;
  final bool isBookMark;
  final bool isCartProduct;
  final String qrCode;
  final int cutoff;
  final String? dateAvailable;
  final bool status;
  final bool isArchived;
  final int addedBy;
  final String userName;
  final String userImage;
  final String imageUrl;
  final String thumbUrl;
  final String qrCodeUrl;

  ProductSetDataInfo({
    required this.setId,
    required this.setName,
    required this.id,
    required this.productId,
    required this.name,
    required this.shortName,
    required this.companyId,
    required this.companyName,
    required this.currency,
    required this.price,
    required this.marketPrice,
    required this.totalAmount,
    required this.qty,
    required this.subQty,
    required this.isSubQty,
    required this.packOffQty,
    required this.packOffUnitId,
    required this.packOffUnit,
    required this.stockStatus,
    required this.stockStatusId,
    required this.statusColor,
    required this.supplierId,
    required this.supplierName,
    required this.supplierCode,
    required this.cartQty,
    required this.cartId,
    required this.isBookMark,
    required this.isCartProduct,
    required this.qrCode,
    required this.cutoff,
    required this.dateAvailable,
    required this.status,
    required this.isArchived,
    required this.addedBy,
    required this.userName,
    required this.userImage,
    required this.imageUrl,
    required this.thumbUrl,
    required this.qrCodeUrl,
  });

  factory ProductSetDataInfo.fromJson(Map<String, dynamic> json) {
    return ProductSetDataInfo(
      setId: json['set_id'] ?? 0,
      setName: json['set_name'] ?? '',
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      currency: json['currency'] ?? '',
      price: json['price'] ?? '0',
      marketPrice: json['market_price'] ?? '0',
      totalAmount: json['total_amount'] ?? '0',
      qty: json['qty'] ?? 0,
      subQty: json['sub_qty'] ?? 0,
      isSubQty: json['is_sub_qty'] ?? false,
      packOffQty: json['pack_off_qty']?.toString() ?? '0',
      packOffUnitId: json['pack_off_unit_id'],
      packOffUnit: json['pack_off_unit'],
      stockStatus: json['stock_status'] ?? '',
      stockStatusId: json['stock_status_id'] ?? 0,
      statusColor: json['status_color'] ?? '',
      supplierId: json['supplier_id'] ?? 0,
      supplierName: json['supplier_name'] ?? '',
      supplierCode: json['supplier_code'] ?? '',
      cartQty: json['cart_qty'] ?? 0,
      cartId: json['cart_id'],
      isBookMark: json['is_book_mark'] ?? false,
      isCartProduct: json['is_cart_product'] ?? false,
      qrCode: json['qr_code'] ?? '',
      cutoff: json['cutoff'] ?? 0,
      dateAvailable: json['date_available'],
      status: json['status'] ?? false,
      isArchived: json['is_archived'] ?? false,
      addedBy: json['added_by'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      thumbUrl: json['thumb_url'] ?? '',
      qrCodeUrl: json['qr_code_url'] ?? '',
    );
  }
}