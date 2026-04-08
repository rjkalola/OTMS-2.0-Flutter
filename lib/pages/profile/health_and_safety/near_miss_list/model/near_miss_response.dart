import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_report_Info.dart';

class NearMissResponse {
  final bool isSuccess;
  final String message;
  final List<NearMissReportInfo> info;

  NearMissResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory NearMissResponse.fromJson(Map<String, dynamic> json) {
    return NearMissResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: (json['info'] as List?)
          ?.map((i) => NearMissReportInfo.fromJson(i))
          .toList() ?? [],
    );
  }
}
