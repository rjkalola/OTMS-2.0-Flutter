import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';

class SettingItem extends StatelessWidget {
  const SettingItem(
      {super.key,
      required this.title,
      required this.iconPath,
      this.iconColor,
      this.onTap});

  final String title;
  final String iconPath;
  final String? iconColor;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 9, 0, 9),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(9),
                width: 44,
                height: 44,
                decoration: AppUtils.getGrayBorderDecoration(
                    color: backgroundColor_(context),
                    borderColor: dividerColor_(context),
                    borderWidth: 1),
                child: ImageUtils.setSvgAssetsImage(
                  path: iconPath,
                  width: 26,
                  height: 26,
                  color: iconColor != null
                      ? Color(AppUtils.haxColor(iconColor!))
                      : primaryTextColor_(context),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 17,
                      color: primaryTextColor_(context),
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
