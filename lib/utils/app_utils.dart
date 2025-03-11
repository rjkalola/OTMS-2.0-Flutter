import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';

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
      Fluttertoast.showToast(
        msg: message,
      );
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

  static bool isAdmin() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    return info.userTypeId == AppConstants.userType.admin;
  }

  static bool isEmployee() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    return info.userTypeId == AppConstants.userType.employee;
  }

  static bool isManager() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    return info.userTypeId == AppConstants.userType.projectManager;
  }

  static bool isSupervisor() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    return info.userTypeId == AppConstants.userType.supervisor;
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
}
