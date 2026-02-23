import 'package:belcka/pages/user_orders/storeman_catalog/model/get_product_images_data_model.dart';

class GetProductsInfoModel {
  int? id;
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
  int? qty;
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
  List<GetProductImagesDataModel>? productImages;
  int addedQty = 1;

  GetProductsInfoModel(
      {this.id,
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
        this.subQty,
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
        this.addedQty = 1
        });

  GetProductsInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    marketPrice = json['market_price'];
    qty = json['qty'];
    subQty = json['sub_qty'];
    totalAmount = json['total_amount'];
    stockStatus = json['stock_status'];
    currency = json['currency'];
    stockStatusId = json['stock_status_id'];
    isSubQty = json['is_sub_qty'];
    packOffQty = json['pack_off_qty'];
    packOffUnitId = json['pack_off_unit_id'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    qrCode = json['qr_code'];
    cutoff = json['cutoff'];
    dateAvailable = json['date_available'];
    status = json['status'];
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
    if (json['product_images'] != null) {
      productImages = <GetProductImagesDataModel>[];
      json['product_images'].forEach((v) {
        productImages!.add(new GetProductImagesDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['sub_qty'] = this.subQty;
    data['total_amount'] = this.totalAmount;
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
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}