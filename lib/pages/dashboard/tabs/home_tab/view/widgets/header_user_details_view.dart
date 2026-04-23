import 'package:belcka/utils/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/shapes/badge_count_with_child_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HeaderUserDetailsView extends StatelessWidget {
  HeaderUserDetailsView({super.key});

  final controller = Get.put(HomeTabController());

  static const double _bottomRadius = 24;

  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMM');
    return formatter.format(now);
  }

  String _displayName() {
    final first = controller.userInfo.value.firstName ?? "";
    final last = controller.userInfo.value.lastName ?? "";
    return "$first $last";
  }

  @override
  Widget build(BuildContext context) {
    final bellColor = ThemeConfig.isDarkMode
        ? AppUtils.getColor("#B7B3AD")
        : AppUtils.getColor("#484C52");
    final avatarBorder = ThemeConfig.isDarkMode
        ? AppUtils.getColor("#5C5C5C")
        : AppUtils.getColor("#484C52");

    return Obx(
      () => Padding(
        // Space so the bottom shadow is not clipped by the parent.
        padding: const EdgeInsets.only(bottom: 0),
        child: Material(
          color: backgroundColor_(context),
          elevation: 8,
          shadowColor: shadowColor_(context).withValues(alpha: 0.35),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(_bottomRadius),
              bottomRight: Radius.circular(_bottomRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (Get.find<AppStorage>().isLocalSequenceChanges()) {
                          controller
                              .changeDashboardUserPermissionMultipleSequenceApi(
                                  isProgress: false,
                                  isLoadPermissionList: false,
                                  isChangeSequence: false);
                        }
                        controller.moveToScreen(
                            appRout: AppRoutes.myAccountScreen);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserAvtarView(
                            imageUrl:
                                controller.userInfo.value.userThumbImage ?? "",
                            isOnlineStatusVisible: true,
                            imageBorderColor: avatarBorder,
                            imageBorderWidth: 1.5,
                            // onlineStatusColor: statusGrey,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PrimaryTextView(
                                  text: _displayName().isEmpty
                                      ? 'Hi'
                                      : 'Hi, ${_displayName()}',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: primaryTextColorLight_(context),
                                  softWrap: true,
                                ),
                                PrimaryTextView(
                                  text: getFormattedDate(),
                                  color: secondaryExtraLightTextColor_(context),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.moveToScreen2(
                        appRout: AppRoutes.notificationListScreen);
                  },
                  child: Obx(
                    () => BudgeCountWithChild(
                      count: controller.notificationCount.value,
                      child: ImageUtils.setSvgAssetsImage(
                        path: Drawable.bellIcon,
                        width: 28,
                        height: 28,
                        color: bellColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
