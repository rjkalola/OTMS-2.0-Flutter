import 'dart:convert';
import 'dart:io';

import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../routes/app_routes.dart';
import 'app_constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final granted = await _requestPermissions();

    if (granted) {
      const InitializationSettings initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        ),
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            notificationClick(data);
          }
        },
      );
    }
  }

  static Future<bool> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;

    // iOS: request Firebase notification permission
    if (Platform.isIOS) {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ iOS: Notification permission granted');
        return true;
      } else {
        print('❌ iOS: Notification permission denied');
        return false;
      }
    }

    // Android: manually request POST_NOTIFICATIONS (required on Android 13+)
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.notification.request();
        if (result.isGranted) {
          print('✅ Android: Notification permission granted');
          return true;
        } else {
          print('❌ Android: Notification permission denied');
          return false;
        }
      }

      print('✅ Android: Notification permission already granted');
      return true;
    }

    // Other platforms (Web, macOS, etc.)
    print(
        'ℹ️ Notification permission not required or unsupported on this platform');
    return false;
  }

  static void showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    print("title:" + notification!.title!);
    print("body:" + notification!.body!);

    if (notification != null) {
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              icon: 'ic_stat_notification',
              // <-- no file extension
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: BigTextStyleInformation(
                notification.body ?? "",
              ),
              showWhen: true,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data));
    } else {
      // AppUtils.showSnackBarMessage("notification null");
    }
  }

  static void handleMessageNavigation(RemoteMessage message) {
    final data = message.data;
    final notificationType = data['notification_type'] ?? "";
    print("notificationType:" + notificationType);

    if (notificationType == "9251" || notificationType == "9251") {
      // Get.offNamed(AppRoutes.orderListScreen);
    }
  }

  static void notificationClick(Map<String, dynamic>? data) {
    if (data != null) {
      print("data:" + data.toString());
      final notificationType = data['notification_type'] ?? "";
      // final company_id = data['company_id'] ?? "";
      // final user_id = data['user_id'] ?? "";
      // final receiver_id = data['receiver_id'] ?? "";
      print("notificationType:::" + notificationType);
      // print("company_id:::" + company_id);
      // print("user_id:::" + user_id);
      // print("receiver_id:::" + receiver_id);

      final requestType = data['request_type'] ?? "0";
      int requestTypeInt =
          !StringHelper.isEmptyString(requestType) ? int.parse(requestType) : 0;
      final userId = data['user_id'] ?? "0";

      int userIdInt = !StringHelper.isEmptyString(userId) ? int.parse(userId) : 0;

      final requestedByUserId = data['requested_by'] ?? "0";
      int requestedByUserIdInt = !StringHelper.isEmptyString(requestedByUserId) ? int.parse(requestedByUserId) : 0;

      final status = data['status'] ?? "";

      //Team
      if (notificationType ==
              AppConstants.notificationType.USER_ADDED_TO_TEAM ||
          notificationType ==
              AppConstants.notificationType.USER_REMOVED_FROM_TEAM) {
        final teamId = data['team_id'] ?? "0";
        print("teamId is:" + teamId);

        String rout = AppRoutes.teamDetailsScreen;
        var arguments = {
          AppConstants.intentKey.teamId:
              !StringHelper.isEmptyString(teamId) ? int.parse(teamId) : 0,
          AppConstants.intentKey.fromNotification: true,
        };
        Get.offAllNamed(rout, arguments: arguments);
      } else if (notificationType ==
              AppConstants.notificationType.TIMESHEET_APPROVE ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_UNAPPROVE ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_CHANGE_HOURS ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_REQUEST_REJECT ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_REQUEST_DELETE ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_TO_BE_PAID ||
          notificationType == AppConstants.notificationType.WORKLOG_APPROVE ||
          notificationType == AppConstants.notificationType.WORKLOG_REJECT ||
          notificationType ==
              AppConstants.notificationType.TIME_CLOCK_EDIT_WORKLOG ||
          notificationType ==
              AppConstants.notificationType.USER_WORK_STOP_AUTOMATICALLY) {
        final workLogId = data['worklog_id'] ?? "0";
        final userId = data['user_id'] ?? "0";
        print("workLogId is:" + workLogId);
        print("userId is:" + userId);
        String rout = AppRoutes.stopShiftScreen;
        var arguments = {
          AppConstants.intentKey.workLogId:
              !StringHelper.isEmptyString(workLogId) ? int.parse(workLogId) : 0,
          AppConstants.intentKey.userId:
              !StringHelper.isEmptyString(userId) ? int.parse(userId) : 0,
          AppConstants.intentKey.fromNotification: true,
        };
        Get.offAllNamed(rout, arguments: arguments);
      } else if (notificationType ==
          AppConstants.notificationType.TIMESHEET_EDIT) {
        final requestLogId = data['request_log_id'] ?? "0";
        final userId = data['user_id'] ?? "0";
        print("requestLogId is:" + requestLogId);
        print("userId is:" + userId);
        String rout = AppRoutes.workLogRequestScreen;
        var arguments = {
          AppConstants.intentKey.ID: !StringHelper.isEmptyString(requestLogId)
              ? int.parse(requestLogId)
              : 0,
          AppConstants.intentKey.userId:
              !StringHelper.isEmptyString(userId) ? int.parse(userId) : 0,
          AppConstants.intentKey.fromNotification: true,
        };
        Get.offAllNamed(rout, arguments: arguments);
      } else if (notificationType ==
          AppConstants.notificationType.ASSIGN_USER_TO_PROJECT) {
        final projectId = data['project_id'] ?? "0";
        print("projectId is:" + projectId);
        String rout = AppRoutes.projectDetailsScreen;
        var arguments = {
          AppConstants.intentKey.projectId:
              !StringHelper.isEmptyString(projectId) ? int.parse(projectId) : 0,
          AppConstants.intentKey.fromNotification: true,
        };
        Get.offAllNamed(rout, arguments: arguments);
      } else if (notificationType ==
          AppConstants.notificationType.JOIN_COMPANY) {
        Get.offAllNamed(AppRoutes.userListScreen);
      } else if (notificationType == AppConstants.notificationType.leaveAdd ||
          notificationType == AppConstants.notificationType.leaveUpdate ||
          notificationType == AppConstants.notificationType.leaveDelete ||
          notificationType == AppConstants.notificationType.leaveRequest ||
          notificationType == AppConstants.notificationType.leaveApprove ||
          notificationType == AppConstants.notificationType.leaveReject) {
        final leaveId = data['record_id'] ?? "";
        if (!StringHelper.isEmptyString(leaveId)) {
          var arguments = {
            AppConstants.intentKey.leaveId:
                !StringHelper.isEmptyString(leaveId) ? int.parse(leaveId) : 0,
            AppConstants.intentKey.fromNotification: true,
          };
          Get.offAllNamed(AppRoutes.leaveDetailsScreen, arguments: arguments);
        } else {
          Get.offAllNamed(AppRoutes.splashScreen);
        }
      }
      //Billing
      else if (notificationType == AppConstants.notificationType.CREATE_BILLING_INFO
          || notificationType == AppConstants.notificationType.UPDATE_BILLING_INFO) {
        String rout = AppRoutes.billingRequestScreen;
        final requestLogId = data['request_log_id'] ?? "0";
        var arguments = {
          "request_log_id": !StringHelper.isEmptyString(requestLogId)
              ? int.parse(requestLogId)
              : 0,
          AppConstants.intentKey.fromNotification: true
        };
        Get.offAllNamed(rout, arguments: arguments);
      }
      else if (notificationType == AppConstants.notificationType.REJECT_REQUEST
          || notificationType == AppConstants.notificationType.APPROVE_REQUEST) {
        if (requestedByUserIdInt == UserUtils.getLoginUserId()) {
          String rout = AppRoutes.billingDetailsNewScreen;
          var arguments = {
            "user_id": requestedByUserIdInt,
            AppConstants.intentKey.fromNotification: true
          };
          Get.offAllNamed(rout, arguments: arguments);
        }
        else{
          String rout = AppRoutes.otherUserBillingDetailsScreen;
          var arguments = {
            "user_id": requestedByUserIdInt,
            AppConstants.intentKey.fromNotification: true
          };
          Get.offAllNamed(rout, arguments: arguments);
        }
      }
      //Rate
      else if (notificationType == AppConstants.notificationType.CHNAGE_RATE || notificationType == AppConstants.notificationType.APPROVE_RATE || notificationType == AppConstants.notificationType.REJECT_RATE) {
        final requestLogId = data['request_log_id'] ?? "0";
        print("request_log_id is:" + requestLogId);
        String rout = AppRoutes.ratesRequestScreen;
        var arguments = {
          "request_log_id": !StringHelper.isEmptyString(requestLogId)
              ? int.parse(requestLogId)
              : 0,
          AppConstants.intentKey.fromNotification: true
        };
        Get.offAllNamed(rout, arguments: arguments);
      }
      else{
        Get.offAllNamed(AppRoutes.splashScreen);
      }
    }
    else{
      Get.offAllNamed(AppRoutes.splashScreen);
    }
  }
}
