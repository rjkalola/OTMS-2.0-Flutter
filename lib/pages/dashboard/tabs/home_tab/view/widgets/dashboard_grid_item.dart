import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class DashboardGridItem extends StatelessWidget {
  DashboardGridItem({super.key, required this.info, required this.index});

  PermissionInfo info;
  int index;
  final controller = Get.put(HomeTabController());

  static const double _cornerRadius = 20;

  bool _isShiftHighlighted() {
    return controller.isOnWorking.value && (info.slug ?? "") == "shift";
  }

  /// Tap + press ripple. Uses InkWell (not GestureDetector) so [LongPressDraggable]
  /// from [ReorderableBuilder] still receives long-press for reorder.
  Widget _interactiveContent(BuildContext context, BorderRadius inkRadius) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: inkRadius,
        onTap: () => controller.onClickPermission(index, info),
        splashColor: isDark
            ? Colors.white.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.32),
        highlightColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.16),
        child: Container( 
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageUtils.setSvgAssetsImage(
                path: "${AppConstants.permissionIconsAssetsPath}${info.icon}",
                width: 26,
                height: 26,
                color: info.color != null
                    ? Color(AppUtils.haxColor(info.color ?? ""))
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !StringHelper.isEmptyString(info.name),
                      child: PrimaryTextView(
                        text: info.name ?? "",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        color: primaryTextColorLight_(context),
                        softWrap: true,
                        maxLine: 2,
                      ),
                    ),
                    Visibility(
                      visible: !StringHelper.isEmptyString(info.value),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: PrimaryTextView(
                          text: info.value ?? "",
                          textAlign: TextAlign.center,
                          color: secondaryExtraLightTextColor_(context),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLine: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final highlight = _isShiftHighlighted();
    final inkRadius = BorderRadius.circular(_cornerRadius);

    // iOS 26+: AdaptiveBlurView uses a native UIKitView behind the child; that layer
    // can eat pointer events and break reorder long-press. Use the same Flutter blur
    // card as Android so drag-and-drop and InkWell both work.
    if (PlatformInfo.isIOS && PlatformInfo.isIOS26OrHigher()) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: CardViewDashboardItem(
          borderColor: highlight ? Colors.green : null,
          borderWidth: highlight ? 2 : 1,
          child: _interactiveContent(context, inkRadius),
        ),
      );
    }

    if (PlatformInfo.isIOS) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: inkRadius,
            border: highlight
                ? Border.all(color: Colors.green, width: 2)
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: AdaptiveBlurView(
            blurStyle: BlurStyle.systemUltraThinMaterial,
            borderRadius: inkRadius,
            child: _interactiveContent(context, inkRadius),
          ),
        ),
      );
    }

    return CardViewDashboardItem(
      borderColor: highlight ? Colors.green : null,
      borderWidth: highlight ? 2 : 1,
      child: _interactiveContent(context, inkRadius),
    );
  }
}
