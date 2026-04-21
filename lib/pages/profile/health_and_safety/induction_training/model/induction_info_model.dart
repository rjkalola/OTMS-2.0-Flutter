import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/profile/health_and_safety/induction_training/model/attachment_item_model.dart';

class InductionInfoModel {
  final int id;
  final String title;
  final String description;
  final int addedBy;
  final String addedByName;
  final String addedByUserThumbImage;
  final List<HSResourceTypesInfo> teams;
  final List<HSResourceTypesInfo> users;
  final List<AttachmentItemModel> files;

  InductionInfoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.addedBy,
    required this.addedByName,
    required this.addedByUserThumbImage,
    required this.teams,
    required this.users,
    required this.files,
  });

  // Helper to check if any files exist
  bool get hasAttachments => files.isNotEmpty;

  factory InductionInfoModel.fromJson(Map<String, dynamic> json) {
    return InductionInfoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      addedBy: json['added_by'] ?? 0,
      addedByName: json['added_by_name'] ?? '',
      addedByUserThumbImage: json['added_by_user_thumb_image'] ?? '',
      teams: (json['teams'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],
      users: (json['users'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],
      files: (json['files'] as List?)?.map((i) => AttachmentItemModel.fromJson(i)).toList() ?? [],
    );
  }
}