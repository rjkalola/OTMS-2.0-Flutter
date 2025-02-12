import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:pdf/widgets.dart';

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

  // static String checkPhoneNumberValidator(String value) {
  //   if (!StringHelper.isEmptyString(value) && value.length < 10) {
  //     return "Phone number must be 10 digit";
  //   }
  //   return ""; // Validation passed
  // }

  static String isValidPhoneNumber(String phoneNumber, String phoneExtension) {
    String message = "";
    print("phoneNumber:"+phoneNumber);
    int phoneNumberDefaultLength = 10;
    if (phoneExtension == "+380" || phoneExtension == 380)
      phoneNumberDefaultLength = 9;
    if (!StringHelper.isEmptyString(phoneNumber)) {
      if (phoneNumber.startsWith("00")) {
        message = 'error_invalid_phone_number'.tr;
      } else if (phoneNumber.startsWith("0")) {
        if (phoneNumber.length != (phoneNumberDefaultLength + 1)) {
          message =
              "Excluding 0, must contain $phoneNumberDefaultLength digits";
        }
      } else if (phoneNumber.length != phoneNumberDefaultLength) {
        message = "Phone number must contain $phoneNumberDefaultLength digits";
      }
    }
    // else {
    //   message = 'required_field'.tr;
    // }
    print("Message123:" + message);
    return message;
  }
}
