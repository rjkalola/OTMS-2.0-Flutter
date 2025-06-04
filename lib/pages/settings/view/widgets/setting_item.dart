import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';

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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(9),
                    width: 44,
                    height: 44,
                    decoration: AppUtils.getGrayBorderDecoration(
                        color: backgroundColor,
                        borderColor: dividerColor,
                        borderWidth: 1),
                    child: ImageUtils.setSvgAssetsImage(
                        path: iconPath,
                        width: 26,
                        height: 26,
                        color:
                            Color(AppUtils.haxColor(iconColor ?? "#000000"))),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 17,
                          color: primaryTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 55, top: 10, right: 0),
                child: Divider(
                  height: 0,
                  color: dividerColor,
                  thickness: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
