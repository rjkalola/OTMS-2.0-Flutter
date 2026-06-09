import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';
import 'package:belcka/pages/notifications/notification_list/model/feed_list_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class AnnouncementListResponse {
  bool? isSuccess;
  String? message;
  int? unreadCount;
  List<AnnouncementInfo>? info;
  PaginationData? pagination;

  AnnouncementListResponse(
      {this.isSuccess, this.message, this.unreadCount, this.info, this.pagination,});

  AnnouncementListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    unreadCount = json['unread_count'];
    if (json['info'] != null) {
      info = <AnnouncementInfo>[];
      json['info'].forEach((v) {
        info!.add(new AnnouncementInfo.fromJson(v));
      });
    }
    pagination=  json['data'] != null ? PaginationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['unread_count'] = this.unreadCount;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
