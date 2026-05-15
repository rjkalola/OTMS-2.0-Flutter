import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/utils/string_helper.dart';

class OfflineWorklogConflictItem {
  OfflineWorklogConflictItem({
    this.worklogId,
    this.startTime,
    this.endTime,
    this.shiftId,
    this.projectId,
    this.shiftName,
    this.projectName,
    this.teamName,
    this.totalMinutes,
    this.totalAmount,
    this.hasConflict,
    this.startWorkLocation,
    this.stopWorkLocation,
  });

  factory OfflineWorklogConflictItem.fromJson(Map<String, dynamic> json) {
    return OfflineWorklogConflictItem(
      worklogId: _intFromJson(
        json['user_worklog_id'] ?? json['worklogId'] ?? json['id'],
      ),
      startTime: (json['work_start_time'] ?? json['startTime']) as String?,
      endTime: (json['work_end_time'] ?? json['endTime']) as String?,
      shiftId: _intFromJson(json['shift_id'] ?? json['shiftId']),
      projectId: _intFromJson(json['project_id'] ?? json['projectId']),
      shiftName: json['shiftName'] as String?,
      projectName: json['projectName'] as String?,
      teamName: json['teamName'] as String?,
      totalMinutes: _intFromJson(json['totalMinutes']),
      totalAmount: json['totalAmount']?.toString(),
      hasConflict: json['hasConflict'] as bool?,
      startWorkLocation: _locationFromJson(json['start_work_location']),
      stopWorkLocation: _locationFromJson(json['stop_work_location']),
    );
  }

  final int? worklogId;
  final String? startTime;
  final String? endTime;
  final int? shiftId;
  final int? projectId;
  final String? shiftName;
  final String? projectName;
  final String? teamName;
  final int? totalMinutes;
  final String? totalAmount;
  final bool? hasConflict;
  final LocationInfo? startWorkLocation;
  final LocationInfo? stopWorkLocation;

  /// Single worklog object for [user-worklog/keep-offline-work].
  Map<String, dynamic> toKeepWorklogJson() {
    final entry = <String, dynamic>{
      'shift_id': shiftId,
      'project_id': projectId,
      'work_start_time': startTime,
    };
    if ((worklogId ?? 0) > 0) {
      entry['user_worklog_id'] = worklogId;
    }
    if (!StringHelper.isEmptyString(endTime)) {
      entry['work_end_time'] = endTime;
    }
    if (startWorkLocation != null) {
      entry['start_work_location'] = startWorkLocation!.toJson();
    }
    if (stopWorkLocation != null) {
      entry['stop_work_location'] = stopWorkLocation!.toJson();
    }
    return entry;
  }

  static LocationInfo? _locationFromJson(dynamic value) {
    if (value == null || value is! Map) return null;
    return LocationInfo.fromJson(Map<String, dynamic>.from(value));
  }

  static int? _intFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static List<OfflineWorklogConflictItem> listFromJson(List<dynamic>? raw) {
    if (raw == null || raw.isEmpty) return [];
    return raw
        .whereType<Map>()
        .map((e) => OfflineWorklogConflictItem.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();
  }
}
