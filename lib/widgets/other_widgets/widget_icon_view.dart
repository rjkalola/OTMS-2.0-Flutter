import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';

class WidgetIconView extends StatelessWidget {
  const WidgetIconView(
      {super.key, required this.iconPath, this.iconColor, this.isAdminWidget});

  final String? iconPath;
  final String? iconColor;
  final bool? isAdminWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
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
                path:
                    "${AppConstants.permissionIconsAssetsPath}${iconPath ?? ""}",
                // path: Drawable.truckPermissionIcon,
                width: 26,
                height: 26,
                color: iconColor != null
                    ? Color(AppUtils.haxColor(iconColor ?? "#000000"))
                    : null),
          ),
          Visibility(
            visible: isAdminWidget ?? false,
            child: Align(
              alignment: Alignment.topRight,
              child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.diamondPermissionIcon, width: 18, height: 18),
            ),
          ),
        ],
      ),
    );
  }
}
