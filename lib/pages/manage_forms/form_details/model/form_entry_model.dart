import 'package:belcka/pages/manage_forms/form_details/model/form_entry_file.dart';

class FormEntrySubmittedBy {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? userImage;
  String? userThumbImage;
  String? tradeName;

  FormEntrySubmittedBy({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.userImage,
    this.userThumbImage,
    this.tradeName,
  });

  FormEntrySubmittedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse('${json['id']}');
    name = json['name']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    image = json['image']?.toString();
    userImage = json['user_image']?.toString();
    userThumbImage = json['user_thumb_image']?.toString();
    tradeName = json['trade_name']?.toString() ?? json['tradeName']?.toString();
  }

  String get fullName {
    final combined = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    if (combined.isNotEmpty) return combined;
    return name ?? '';
  }

  String get avatarUrl {
    final thumb = userThumbImage?.trim();
    if (thumb != null && thumb.isNotEmpty) return thumb;
    final userImg = userImage?.trim();
    if (userImg != null && userImg.isNotEmpty) return userImg;
    return image ?? '';
  }
}

class FormEntryModel {
  int? id;
  int? companyId;
  int? formId;
  int? submittedById;
  Map<String, dynamic>? data;
  String? createdAt;
  String? updatedAt;
  FormEntrySubmittedBy? submittedBy;

  FormEntryModel({
    this.id,
    this.companyId,
    this.formId,
    this.submittedById,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.submittedBy,
  });

  FormEntryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    formId = json['form_id'];
    submittedById = json['submitted_by_id'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();

    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(rawData);
    } else if (rawData is Map) {
      data = rawData.map((key, value) => MapEntry(key.toString(), value));
    }

    final submittedByJson = json['submittedBy'] ?? json['submitted_by'];
    submittedBy = submittedByJson is Map
        ? FormEntrySubmittedBy.fromJson(
            Map<String, dynamic>.from(submittedByJson),
          )
        : null;
  }

  dynamic valueFor(String? fieldId) {
    if (fieldId == null || data == null) return null;
    return data![fieldId];
  }

  String? textValueFor(String? fieldId) {
    final value = valueFor(fieldId);
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  List<FormEntryFile> filesFor(String? fieldId) {
    final value = valueFor(fieldId);
    if (value == null) return const [];

    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => FormEntryFile.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (value is Map) {
      return [FormEntryFile.fromJson(Map<String, dynamic>.from(value))];
    }

    return const [];
  }

  FormEntryFile? singleFileFor(String? fieldId) {
    final files = filesFor(fieldId);
    return files.isEmpty ? null : files.first;
  }

  String get displayName => submittedBy?.fullName ?? '';

  String get tradeName => submittedBy?.tradeName ?? '';

  String get avatarUrl => submittedBy?.avatarUrl ?? '';
}
