import 'package:belcka/utils/app_constants.dart';

class CertificateInfo {
  int? id;
  int? type;
  String? documentType;
  String? cardNumber;
  String? expiryDate;
  String? status;
  String? fileUrl;
  String? uploadedDate;
  String? userName;
  String? userImage;
  String? validUntil;
  int? expiresInDays;

  bool get isInsurance => type == AppConstants.certificateTypeInsurance;

  CertificateInfo({
    this.id,
    this.type,
    this.documentType,
    this.cardNumber,
    this.expiryDate,
    this.status,
    this.fileUrl,
    this.uploadedDate,
    this.userName,
    this.userImage,
    this.validUntil,
    this.expiresInDays,
  });

  CertificateInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    documentType = json['document_type'];
    cardNumber = json['card_number'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    fileUrl = json['file_url'];
    uploadedDate = json['uploaded_date'];
    userName = json['user_name'];
    userImage = json['user_image'];
    validUntil = json['valid_until'];
    expiresInDays = json['expires_in_days'];
  }
}
