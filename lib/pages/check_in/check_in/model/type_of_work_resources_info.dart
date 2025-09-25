import 'package:belcka/pages/common/model/file_info.dart';

class TypeOfWorkResourcesInfo {
  int? id, companyTaskId, typeOfWorkId;
  String? name;
  int? companyId;
  String? companyName;
  int? tradeId;
  String? tradeName;
  String? startDate;
  String? duration;
  bool? isPricework;
  String? rate;
  String? repeatableJob;
  String? units;
  String? locationName;
  List<FilesInfo>? beforeAttachments;
  List<FilesInfo>? afterAttachments;
  int? progress;
  bool? isCheck;

  TypeOfWorkResourcesInfo(
      {this.id,
      this.companyTaskId,
      this.typeOfWorkId,
      this.name,
      this.companyId,
      this.companyName,
      this.tradeId,
      this.tradeName,
      this.startDate,
      this.duration,
      this.isPricework,
      this.rate,
      this.repeatableJob,
      this.units,
      this.locationName,
      this.beforeAttachments,
      this.afterAttachments,
      this.progress,
      this.isCheck});

  TypeOfWorkResourcesInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyTaskId = json['company_task_id'];
    typeOfWorkId = json['type_of_work_id'];
    name = json['name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    startDate = json['start_date'];
    duration = json['duration'];
    isPricework = json['is_pricework'];
    rate = json['rate'];
    repeatableJob = json['repeatable_job'];
    units = json['units'];
    locationName = json['location_name'];
    if (json['before_attachments'] != null) {
      beforeAttachments = <FilesInfo>[];
      json['before_attachments'].forEach((v) {
        beforeAttachments!.add(new FilesInfo.fromJson(v));
      });
    }
    if (json['after_attachments'] != null) {
      afterAttachments = <FilesInfo>[];
      json['after_attachments'].forEach((v) {
        afterAttachments!.add(new FilesInfo.fromJson(v));
      });
    }
    progress = json['progress'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_task_id'] = this.companyTaskId;
    data['type_of_work_id'] = this.typeOfWorkId;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['start_date'] = this.startDate;
    data['duration'] = this.duration;
    data['is_pricework'] = this.isPricework;
    data['rate'] = this.rate;
    data['repeatable_job'] = this.repeatableJob;
    data['units'] = this.units;
    data['location_name'] = this.locationName;
    if (this.beforeAttachments != null) {
      data['before_attachments'] =
          this.beforeAttachments!.map((v) => v.toJson()).toList();
    }
    if (this.afterAttachments != null) {
      data['after_attachments'] =
          this.afterAttachments!.map((v) => v.toJson()).toList();
    }
    data['progress'] = this.progress;
    data['isCheck'] = this.isCheck;
    return data;
  }

  /// ✅ Copy method
  TypeOfWorkResourcesInfo copyWith({
    int? id,
    int? companyTaskId,
    int? typeOfWorkId,
    String? name,
    int? companyId,
    String? companyName,
    int? tradeId,
    String? tradeName,
    String? startDate,
    String? duration,
    bool? isPricework,
    String? rate,
    String? repeatableJob,
    String? units,
    String? locationName,
    List<FilesInfo>? beforeAttachments,
    List<FilesInfo>? afterAttachments,
    int? progress,
    bool? isCheck,
  }) {
    return TypeOfWorkResourcesInfo(
      id: id ?? this.id,
      companyTaskId: companyTaskId ?? this.companyTaskId,
      typeOfWorkId: typeOfWorkId ?? this.typeOfWorkId,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      tradeId: tradeId ?? this.tradeId,
      tradeName: tradeName ?? this.tradeName,
      startDate: startDate ?? this.startDate,
      duration: duration ?? this.duration,
      isPricework: isPricework ?? this.isPricework,
      rate: rate ?? this.rate,
      repeatableJob: repeatableJob ?? this.repeatableJob,
      units: units ?? this.units,
      locationName: locationName ?? this.locationName,
      beforeAttachments: beforeAttachments ?? this.beforeAttachments,
      afterAttachments: afterAttachments ?? this.afterAttachments,
      progress: progress ?? this.progress,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
