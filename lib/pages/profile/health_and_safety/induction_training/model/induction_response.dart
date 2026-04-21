import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/induction_training/model/induction_info_model.dart';

class InductionResponse {
  final bool isSuccess;
  final String message;
  final List<InductionInfoModel> info;

  InductionResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory InductionResponse.fromJson(Map<String, dynamic> json) {
    return InductionResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: (json['info'] as List?)
          ?.map((item) => InductionInfoModel.fromJson(item))
          .toList() ?? [],
    );
  }
}