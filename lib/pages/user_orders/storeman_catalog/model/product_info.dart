import 'package:belcka/pages/common/model/file_info.dart';
import 'package:flutter/material.dart';

class ProductInfo {
  int? id;
  int? productId;
  int? companyId;
  String? companyName;
  String? uuid;
  int? sortId;
  String? shortName;
  int? supplierId;
  String? supplierName;
  String? supplierCode;
  String? name;
  String? description;
  String? price;
  String? marketPrice;
  double? qty;
  double? cartQty;
  String? subQty;
  String? totalAmount;
  String? stockStatus;
  String? currency;
  int? stockStatusId;
  bool? isSubQty;
  String? packOffQty;
  int? packOffUnitId;
  String? imageUrl;
  String? thumbUrl;
  String? qrCode;
  int? cutoff;
  int? dateAvailable;
  bool? status;
  bool? isArchived;
  int? addedBy;
  String? userName;
  String? userImage;
  String? qrCodeUrl;
  bool? isBookMark;
  bool? isCartProduct;
  int? modelId;
  String? modelName;
  int? manufacturerId;
  String? manufacturerName;
  int? weightUnitId;
  String? weightUnit;
  int? lengthUnitId;
  String? lengthUnit;
  String? weight;
  String? length;
  String? width;
  String? height;
  String? tax;
  String? tags;
  String? barcodeText;
  String? productCategories;
  String? categoryIds;
  String? storeIds;
  int? cartId;
  List<FilesInfo>? productImages;
  List<FilesInfo>? attachments;
  List<FilesInfo>? tempAttachments;
  int? deliveredQty;
  int? receivedQty;
  int? totalQty;
  String? manufactureName;
  double? availableQty;
  int? remainingQty;
  String? storeName;
  String? orderUsersDisplay;
  int? orderUserCount;
  int? pendingQty;
  int? cancelledQty;
  String? projectName;
  String? productImage;
  String? productThumbImage;
  String? packOfUnit;
  String? packOfUnitName;
  String? note;
  List<String>? notes;
  String? tempNote;
  bool? isCheck;
  bool? isInSet;

  int? orderStatus;
  String? orderStatusText;
  String? orderStatusColor;
  String? date;
  String? fromDate;
  String? toDate;
  String? fromDateFormate;
  String? toDateFormate;
  String? orderId;
  int? orderIdInt;
  int? approvedBy;
  String? approveByUserName;
  String? approvedAt;

  FocusNode qtyFocusNode = FocusNode();

  ProductInfo(
      {this.id,
      this.productId,
      this.companyId,
      this.companyName,
      this.uuid,
      this.sortId,
      this.shortName,
      this.supplierId,
      this.supplierName,
      this.supplierCode,
      this.name,
      this.description,
      this.price,
      this.marketPrice,
      this.qty,
      this.cartQty,
      this.subQty,
      this.receivedQty,
      this.deliveredQty,
      this.totalQty,
      this.manufactureName,
      this.totalAmount,
      this.stockStatus,
      this.currency,
      this.stockStatusId,
      this.isSubQty,
      this.packOffQty,
      this.packOffUnitId,
      this.imageUrl,
      this.thumbUrl,
      this.qrCode,
      this.cutoff,
      this.dateAvailable,
      this.status,
      this.isArchived,
      this.addedBy,
      this.userName,
      this.userImage,
      this.qrCodeUrl,
      this.isBookMark,
      this.isCartProduct,
      this.modelId,
      this.modelName,
      this.manufacturerId,
      this.manufacturerName,
      this.weightUnitId,
      this.weightUnit,
      this.lengthUnitId,
      this.lengthUnit,
      this.weight,
      this.length,
      this.width,
      this.height,
      this.tax,
      this.tags,
      this.barcodeText,
      this.productCategories,
      this.categoryIds,
      this.storeIds,
      this.productImages,
      this.attachments,
      this.tempAttachments,
      this.cartId,
      this.availableQty,
      this.remainingQty,
      this.storeName,
      this.orderUsersDisplay,
      this.orderUserCount,
      this.pendingQty,
      this.cancelledQty,
      this.projectName,
      this.productImage,
      this.productThumbImage,
      this.packOfUnit,
      this.packOfUnitName,
      this.note,
      this.notes,
      this.tempNote,
      this.isCheck});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    uuid = json['uuid'];
    sortId = json['sort_id'];
    shortName = json['short_name'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    supplierCode = json['supplier_code'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    marketPrice = json['market_price']?.toString();
    qty = (json['qty'] as num?)?.toDouble();
    cartQty = (json['cart_qty'] as num?)?.toDouble();
    subQty = json['sub_qty']?.toString();
    totalAmount = json['total_amount'];
    stockStatus = json['stock_status'];
    currency = json['currency'];
    stockStatusId = json['stock_status_id'];
    isSubQty = json['is_sub_qty'];
    packOffQty = json['pack_off_qty']?.toString();
    packOffUnitId = json['pack_off_unit_id'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    qrCode = json['qr_code'];
    cutoff = json['cutoff'];
    dateAvailable = json['date_available'];
    isArchived = json['is_archived'];
    addedBy = json['added_by'];
    userName = json['user_name'];
    userImage = json['user_image'];
    qrCodeUrl = json['qr_code_url'];
    isBookMark = json['is_book_mark'];
    isCartProduct = json['is_cart_product'];
    modelId = json['model_id'];
    modelName = json['model_name'];
    manufacturerId = json['manufacturer_id'];
    manufacturerName = json['manufacturer_name'];
    weightUnitId = json['weight_unit_id'];
    weightUnit = json['weight_unit'];
    lengthUnitId = json['length_unit_id'];
    lengthUnit = json['length_unit'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    tax = json['tax'];
    tags = json['tags'];
    barcodeText = json['barcode_text'];
    productCategories = json['product_categories'];
    categoryIds = json['category_ids'];
    storeIds = json['store_ids'];
    cartId = json['cart_id'];
    if (json['product_images'] != null) {
      productImages = <FilesInfo>[];
      json['product_images'].forEach((v) {
        productImages!.add(new FilesInfo.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = <FilesInfo>[];
      json['attachments'].forEach((v) {
        attachments!.add(new FilesInfo.fromJson(v));
      });
    }
    if (json['temp_attachments'] != null) {
      tempAttachments = <FilesInfo>[];
      json['temp_attachments'].forEach((v) {
        tempAttachments!.add(new FilesInfo.fromJson(v));
      });
    }
    receivedQty = json['received_qty'];
    deliveredQty = json['delivered_qty'];
    totalQty = json['total_qty'];
    manufactureName = json['manufacturer_name'];
    availableQty = (json['available_qty'] as num?)?.toDouble();
    remainingQty = json['remaining_qty'];
    storeName = json['store_name'];
    orderUsersDisplay = json['order_users_display'];
    orderUserCount = json['order_user_count'];
    pendingQty = json['pending_qty'];
    cancelledQty = json['cancelled_qty'];
    projectName = json['project_name'];
    productImage = json['product_image'];
    productThumbImage = json['product_thumb_image'];
    packOfUnit = json['pack_off_unit'];
    packOfUnitName = json['pack_off_unit_name'];
    note = json['note'];
    if (json['notes'] != null) {
      notes = List<String>.from(json['notes']);
    }
    tempNote = json['temp_note'];
    isCheck = json['is_check'];
    isInSet = json['is_in_set'];

    final dynamic orderStatusVal = json['order_status'];
    if (orderStatusVal is int) {
      orderStatus = orderStatusVal;
    } else if (orderStatusVal != null) {
      orderStatus = int.tryParse(orderStatusVal.toString());
    }
    orderStatusText = json['order_status_text']?.toString();
    orderStatusColor = json['order_status_color']?.toString();
    date = json['date']?.toString();
    fromDate = json['from_date']?.toString();
    toDate = json['to_date']?.toString();
    fromDateFormate = json['from_date_formate']?.toString();
    toDateFormate = json['to_date_formate']?.toString();
    orderId = json['order_id']?.toString();
    final dynamic orderIdIntVal = json['order_id_int'] ?? json['order_id'];
    if (orderIdIntVal is int) {
      orderIdInt = orderIdIntVal;
    } else if (orderIdIntVal != null) {
      orderIdInt = int.tryParse(orderIdIntVal.toString());
    }
    final dynamic approvedByVal = json['approved_by'];
    if (approvedByVal is int) {
      approvedBy = approvedByVal;
    } else if (approvedByVal != null) {
      approvedBy = int.tryParse(approvedByVal.toString());
    }
    approveByUserName = json['approve_by_user_name']?.toString();
    approvedAt = json['approved_at']?.toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['uuid'] = this.uuid;
    data['sort_id'] = this.sortId;
    data['short_name'] = this.shortName;
    data['supplier_id'] = this.supplierId;
    data['supplier_name'] = this.supplierName;
    data['supplier_code'] = this.supplierCode;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['market_price'] = this.marketPrice;
    data['qty'] = this.qty;
    data['cart_qty'] = this.cartQty;
    data['sub_qty'] = this.subQty;
    data['stock_status'] = this.stockStatus;
    data['currency'] = this.currency;
    data['stock_status_id'] = this.stockStatusId;
    data['is_sub_qty'] = this.isSubQty;
    data['pack_off_qty'] = this.packOffQty;
    data['pack_off_unit_id'] = this.packOffUnitId;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    data['qr_code'] = this.qrCode;
    data['cutoff'] = this.cutoff;
    data['date_available'] = this.dateAvailable;
    data['status'] = this.status;
    data['is_archived'] = this.isArchived;
    data['added_by'] = this.addedBy;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['qr_code_url'] = this.qrCodeUrl;
    data['is_book_mark'] = this.isBookMark;
    data['is_cart_product'] = this.isCartProduct;
    data['model_id'] = this.modelId;
    data['model_name'] = this.modelName;
    data['manufacturer_id'] = this.manufacturerId;
    data['manufacturer_name'] = this.manufacturerName;
    data['weight_unit_id'] = this.weightUnitId;
    data['weight_unit'] = this.weightUnit;
    data['length_unit_id'] = this.lengthUnitId;
    data['length_unit'] = this.lengthUnit;
    data['weight'] = this.weight;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['tax'] = this.tax;
    data['tags'] = this.tags;
    data['barcode_text'] = this.barcodeText;
    data['product_categories'] = this.productCategories;
    data['category_ids'] = this.categoryIds;
    data['store_ids'] = this.storeIds;
    data['cart_id'] = this.cartId;
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    if (this.tempAttachments != null) {
      data['temp_attachments'] =
          this.tempAttachments!.map((v) => v.toJson()).toList();
    }

    data['received_qty'] = this.receivedQty;
    data['delivered_qty'] = this.deliveredQty;
    data['total_qty'] = this.totalQty;
    data['manufacturer_name'] = this.manufactureName;
    data['total_amount'] = this.totalAmount;

    data['available_qty'] = this.availableQty;
    data['remaining_qty'] = this.remainingQty;
    data['store_name'] = this.storeName;
    data['order_users_display'] = this.orderUsersDisplay;
    data['order_user_count'] = this.orderUserCount;
    data['pending_qty'] = this.pendingQty;
    data['cancelled_qty'] = this.cancelledQty;
    data['project_name'] = this.projectName;
    data['product_image'] = this.productImage;
    data['product_thumb_image'] = this.productThumbImage;
    data['pack_off_unit'] = this.packOfUnit;
    data['pack_off_unit_name'] = this.packOfUnitName;
    data['note'] = this.note;
    data['notes'] = this.notes;
    data['temp_note'] = this.tempNote;
    data['is_check'] = this.isCheck;
    data['is_in_set'] = this.isInSet;

    data['order_status'] = this.orderStatus;
    data['order_status_text'] = this.orderStatusText;
    data['order_status_color'] = this.orderStatusColor;
    data['date'] = this.date;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['from_date_formate'] = this.fromDateFormate;
    data['to_date_formate'] = this.toDateFormate;
    data['order_id'] = this.orderId;
    data['order_id_int'] = this.orderIdInt;
    data['approved_by'] = this.approvedBy;
    data['approve_by_user_name'] = this.approveByUserName;
    data['approved_at'] = this.approvedAt;

    return data;
  }
}
