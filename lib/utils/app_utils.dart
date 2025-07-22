import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_controller.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class AppUtils {
  static var mTime;

  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static showSnackBarMessage(String message) {
    if (message.isNotEmpty) {
      // Fluttertoast.showToast(
      //   msg: message,
      // );
      Get.rawSnackbar(message: message);
    }
  }

  static showToastMessage(String message) {
    if (message.isNotEmpty) {
      BotToast.showText(
        text: message,
        align: Alignment.bottomCenter, // or .center
        duration: Duration(seconds: 1),
      );
      // Fluttertoast.showToast(
      //   msg: message,
      // );
    }
  }

  static showApiResponseMessage(String? message) {
    if (!StringHelper.isEmptyString(message)) {
      BotToast.showText(
        text: message ?? "",
        align: Alignment.bottomCenter, // or .center
        duration: Duration(seconds: 1),
      );
      /* Fluttertoast.showToast(
        msg: message ?? "",
      );*/
      // Get.rawSnackbar(message: message);
    }
  }

  static getStringTr(String key) {
    return key.tr;
  }

  static showErrorMessage() {}

  static Future<String> getDeviceName() async {
    String deviceName = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model.isNotEmpty ? androidInfo.model : "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName =
          iosInfo.utsname.machine.isNotEmpty ? iosInfo.utsname.machine : "";
    }
    return deviceName;
  }

  static Future<String> getDeviceUniqueId() async {
    String deviceId = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    }
    return deviceId;
  }

  static haxColor(String colorHexCode) {
    String colorNew = '0xff$colorHexCode';
    colorNew = colorNew.replaceAll("#", '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

  static Color getColor(String colorHexCode) {
    String colorNew = '0xff$colorHexCode';
    colorNew = colorNew.replaceAll("#", '');
    int colorInt = int.parse(colorNew);
    return Color(colorInt);
  }


  static Future<bool> interNetCheck() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(minutes: 3); //3 minutes
      dio.options.receiveTimeout = const Duration(minutes: 3); //3 minutes
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  static bool isPermission(bool? value) {
    return value != null && value;
  }

  static bool isUserCheckIn(int? value) {
    return value != null && value > 0;
  }

  static int getLoginUserId() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    return info.id ?? 0;
  }

  static bool isAdmin() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.admin;
    return false;
  }

  static bool isEmployee() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.employee;
    return false;
  }

  static bool isManager() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.projectManager;
    return false;
  }

  static bool isSupervisor() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.supervisor;
    return false;
  }

  static BoxShadow boxShadow(Color color, double radius) {
    return BoxShadow(
      blurRadius: radius,
      color: color,
    );
  }

  static saveLoginUser(UserInfo user) {
    List<UserInfo> list = Get.find<AppStorage>().getLoginUsers();
    print("before length:" + list.length.toString());
    bool isUserFound = false;
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == user.id) {
          isUserFound = true;
          break;
        }
      }
    }
    if (!isUserFound) {
      list.add(user);
      Get.find<AppStorage>().setLoginUsers(list);
      print("after length:" +
          Get.find<AppStorage>().getLoginUsers().length.toString());
    }
  }

  static BoxDecoration getGrayBorderDecoration(
      {Color? color,
      double? radius,
      double? borderWidth,
      Color? borderColor,
      List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: color ?? Colors.transparent,
      boxShadow: boxShadow ?? null,
      border: Border.all(
          width: borderWidth ?? 0.6, color: borderColor ?? Colors.transparent),
      borderRadius: BorderRadius.circular(radius ?? 12),
    );
  }

  static BoxDecoration getDashboardItemDecoration(
      {Color? color,
      double? radius,
      double? borderWidth,
      Color? borderColor,
      double? shadowRadius,
      List<BoxShadow>? boxShadow}) {
    bool isDark = Get.find<ThemeController>().isDarkMode;
    return BoxDecoration(
      color: color ?? backgroundColor_(Get.context!),
      boxShadow: boxShadow ??
          [AppUtils.boxShadow(shadowColor_(Get.context!), shadowRadius ?? 6)],
      border: Border.all(
          width: borderWidth ?? 0.6,
          color: borderColor ?? (isDark?Color(0xFF1F1F1F):Colors.grey.shade300)),
      borderRadius: BorderRadius.circular(radius ?? 45),
    );
  }

  static String getFlagByExtension(String? extension) {
    String flag = AppConstants.defaultFlagUrl;
    if (!StringHelper.isEmptyString(extension)) {
      final match = DataUtils.getPhoneExtensionList()
          .firstWhere((item) => item.phoneExtension == extension);
      return match.flagImage ?? flag;
    }
    return flag;
  }

  static void copyText(String? value) {
    if (!StringHelper.isEmptyString(value)) {
      Clipboard.setData(ClipboardData(text: value ?? ""));
      AppUtils.showToastMessage('copied_to_clip_board'.tr);
    }
  }

  static Color getStatusColor(int status) {
    Color color = primaryTextColor_(Get.context!);
    if (status == AppConstants.status.approved) {
      color = Colors.green;
    } else if (status == AppConstants.status.rejected) {
      color = Colors.red;
    } else if (status == AppConstants.status.pending) {
      color = Colors.orange;
    }
    return color;
  }

  static void setStatusBarColor() {
    ThemeController themeController = Get.find();
    bool isDarkMode = themeController.isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

}
