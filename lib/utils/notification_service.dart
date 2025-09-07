import 'dart:convert';
import 'dart:io';

import 'package:belcka/utils/string_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../routes/app_routes.dart';

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
    print("title:"+notification!.title!);
    print("body:"+notification!.body!);

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
      final notificationType = data['notification_type'] ?? "";
      print("notificationType:" + notificationType);
      final orderId = data['order_id'] ?? "";
      print("orderId:::" + orderId);

      if ((notificationType == "9251" || notificationType == "9252") &&
          !StringHelper.isEmptyString(orderId)) {
        print("1111");
        // String rout = AppRoutes.orderDetailsScreen;
        // var arguments = {
        //   AppConstants.intentKey.mId: int.parse(orderId),
        //   AppConstants.intentKey.fromNotification: true,
        // };
        // Get.offNamed(rout, arguments: arguments);
      } else {
        print("2222");
        Get.offAllNamed(AppRoutes.splashScreen);
      }
    } else {
      print("3333");
      Get.offAllNamed(AppRoutes.splashScreen);
    }
  }
}
