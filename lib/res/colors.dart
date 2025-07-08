import 'package:flutter/material.dart';
import 'package:otm_inventory/res/theme/app_theme_extension.dart';

const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const primaryTextColor = Color(0xff1A1A1A);
const primaryTextColorLight = Color(0xff262626);
const secondaryTextColor = Color(0xff737373);
const secondaryLightTextColor = Color(0xff606a74);
const secondaryExtraLightTextColor = Color(0xff979797);
const defaultAccentColor = Color(0xff0065ff);
const defaultAccentLightColor = Color(0xff89b0f4);
const backgroundColor = Color(0xffffffff);
const statusBarColor = Color(0xffffffff);
const statusBarComponentColor = Colors.black;
const titleBgColor = Color(0xffF4F5F7);
const snackBarColor = Color(0xff484848);
const dividerColor = Color(0xffe6eaee);
const bottomTabBackgroundColor = Color(0xfff4f5f7);
const hintColor = Color(0xffbdbdbd);
const normalTextFieldBorderColor = Color(0xffbdbdbd);
const focusedTextFieldBorderColor = Color(0xff6e6e6e);
const normalTextFieldBorderDarkColor = Color(0xff7a7a7a);
const focusedTextFieldBorderDarkColor = Color(0xff616161);
const rectangleBorderColor = Color(0xffcdcdce);
const disableComponentColor = Color(0xffc6c6c6);
const darkYellowColor = Color(0xffefcc78);
const dashBoardTabBgColor = Color(0xfff4f5f7);
const dashBoardBgColor = Color(0xffF4F6F8);
Color dashBoardItemStrokeColor = Colors.grey.shade300;
const blueBGButtonColor = Color(0xff007AFF);

Color dashBoardBgColor_(BuildContext context) {
  return Theme.of(context).extension<AppThemeExtension>()!.dashboardBgColor;
}
