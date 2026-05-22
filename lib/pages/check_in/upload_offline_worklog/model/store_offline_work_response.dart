import 'package:belcka/pages/check_in/upload_offline_worklog/model/offline_worklog_conflict_item.dart';

class StoreOfflineWorkResponse {
  StoreOfflineWorkResponse({
    this.isSuccess,
    this.message,
    this.data,
    this.activeCompanyId,
    this.isRateApproved,
  });

  factory StoreOfflineWorkResponse.fromJson(Map<String, dynamic> json) {
    return StoreOfflineWorkResponse(
      isSuccess: json['IsSuccess'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? StoreOfflineWorkData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
      activeCompanyId: json['active_company_id'],
      isRateApproved: json['is_rate_approved'] as bool?,
    );
  }

  final bool? isSuccess;
  final String? message;
  final StoreOfflineWorkData? data;
  final dynamic activeCompanyId;
  final bool? isRateApproved;
}

class StoreOfflineWorkData {
  StoreOfflineWorkData({
    this.hasConflicts,
    this.conflicts,
    this.conflictCount,
    this.instruction,
  });

  factory StoreOfflineWorkData.fromJson(Map<String, dynamic> json) {
    final List<StoreOfflineWorkConflictGroup> groups = [];
    if (json['conflicts'] != null) {
      for (final item in json['conflicts'] as List) {
        if (item is Map) {
          groups.add(StoreOfflineWorkConflictGroup.fromJson(
            Map<String, dynamic>.from(item),
          ));
        }
      }
    }
    return StoreOfflineWorkData(
      hasConflicts: json['hasConflicts'] as bool?,
      conflicts: groups,
      conflictCount: json['conflictCount'],
      instruction: json['instruction'] as String?,
    );
  }

  final bool? hasConflicts;
  final List<StoreOfflineWorkConflictGroup>? conflicts;
  final int? conflictCount;
  final String? instruction;
}

class StoreOfflineWorkConflictGroup {
  StoreOfflineWorkConflictGroup({
    this.offlineWorklog,
    this.existingWorklogs,
  });

  factory StoreOfflineWorkConflictGroup.fromJson(Map<String, dynamic> json) {
    final offline = _parseConflictWorklog(json['offlineWorklog']);
    final existing = <OfflineWorklogConflictItem>[];

    final existingNode = json['existingWorklog'] ?? json['existingWorklogs'];
    if (existingNode is Map) {
      final item = _parseConflictWorklog(existingNode);
      if (item != null) existing.add(item);
    } else if (existingNode is List) {
      for (final entry in existingNode) {
        if (entry is Map) {
          final item = _parseConflictWorklog(entry);
          if (item != null) existing.add(item);
        }
      }
    }

    return StoreOfflineWorkConflictGroup(
      offlineWorklog: offline,
      existingWorklogs: existing,
    );
  }

  /// API may send a flat worklog object or `{ worklogs: [ {...} ] }`.
  static OfflineWorklogConflictItem? _parseConflictWorklog(dynamic node) {
    if (node == null || node is! Map) return null;
    final map = Map<String, dynamic>.from(node);
    final worklogs = map['worklogs'];
    if (worklogs is List && worklogs.isNotEmpty) {
      final first = worklogs.first;
      if (first is Map) {
        return OfflineWorklogConflictItem.fromJson(
          Map<String, dynamic>.from(first),
        );
      }
      return null;
    }
    return OfflineWorklogConflictItem.fromJson(map);
  }

  final OfflineWorklogConflictItem? offlineWorklog;
  final List<OfflineWorklogConflictItem>? existingWorklogs;

  List<OfflineWorklogConflictItem> sheetItems() {
    final items = <OfflineWorklogConflictItem>[];
    if (offlineWorklog != null) items.add(offlineWorklog!);
    final existing = existingWorklogs ?? [];
    if (existing.isNotEmpty) items.add(existing.first);
    return items;
  }
}
