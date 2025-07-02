import 'package:otm_inventory/pages/shifts/create_shift/model/break_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/week_day_info.dart';

class ShiftInfo {
  int? id;
  int? companyId;
  String? name;
  bool? isPricework;
  List<WeekDayInfo>? weekDays;
  String? startTime;
  String? endTime;
  String? removeBreakIds;
  String? showFrequncy;
  bool? status;
  List<BreakInfo>? breaks;

  ShiftInfo({this.id,
    this.companyId,
    this.name,
    this.isPricework,
    this.weekDays,
    this.startTime,
    this.endTime,
    this.breaks,
    this.showFrequncy,
    this.status,
    this.removeBreakIds,});

  ShiftInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    isPricework = json['is_pricework'];
    if (json['week_days'] != null) {
      weekDays = <WeekDayInfo>[];
      json['week_days'].forEach((v) {
        weekDays!.add(new WeekDayInfo.fromJson(v));
      });
    }
    startTime = json['start_time'];
    endTime = json['end_time'];
    removeBreakIds = json['remove_break_ids'];
    showFrequncy = json['show_frequncy'];
    status = json['status'];
    if (json['breaks'] != null) {
      breaks = <BreakInfo>[];
      json['breaks'].forEach((v) {
        breaks!.add(new BreakInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['is_pricework'] = this.isPricework;
    if (this.weekDays != null) {
      data['week_days'] = this.weekDays!.map((v) => v.toJson()).toList();
    }
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['remove_break_ids'] = this.removeBreakIds;
    data['show_frequncy'] = this.showFrequncy;
    data['status'] = status;
    if (this.breaks != null) {
      data['breaks'] = this.breaks!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ShiftInfo copyShiftInfo({ShiftInfo? shiftInfo}) {
    return ShiftInfo(
        id: shiftInfo?.id ?? this.id,
        companyId: shiftInfo?.companyId ?? this.companyId,
        name: shiftInfo?.name ?? this.name,
        isPricework: shiftInfo?.isPricework ?? this.isPricework,
        weekDays: shiftInfo?.weekDays ?? this.weekDays,
        startTime: shiftInfo?.startTime ?? this.startTime,
        endTime: shiftInfo?.endTime ?? this.endTime,
        removeBreakIds: shiftInfo?.removeBreakIds ?? this.removeBreakIds,
        showFrequncy: shiftInfo?.showFrequncy ?? this.showFrequncy,
        breaks: shiftInfo?.breaks ?? this.breaks);
  }
}
