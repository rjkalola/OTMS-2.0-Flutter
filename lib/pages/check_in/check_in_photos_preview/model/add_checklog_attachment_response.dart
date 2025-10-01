import 'package:belcka/pages/common/model/file_info.dart';

class AddCheckLogAttachmentResponse {
  bool? isSuccess;
  String? message;
  List<FilesInfo>? beforeAttachments;
  List<FilesInfo>? afterAttachments;

  AddCheckLogAttachmentResponse(
      {this.isSuccess,
      this.message,
      this.beforeAttachments,
      this.afterAttachments});

  AddCheckLogAttachmentResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.beforeAttachments != null) {
      data['before_attachments'] =
          this.beforeAttachments!.map((v) => v.toJson()).toList();
    }
    if (this.afterAttachments != null) {
      data['after_attachments'] =
          this.afterAttachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
