import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

import '../../../../../../routes/app_routes.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/user_utils.dart';

class EditWidgetsButton extends StatelessWidget {
  EditWidgetsButton({super.key});

  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      child: CardViewDashboardItem(
          child: GestureDetector(
        onTap: () {
          var arguments = {
            AppConstants.intentKey.userId: UserUtils.getLoginUserId(),
            AppConstants.intentKey.userName: UserUtils.getLoginUserName(),
            AppConstants.intentKey.fromDashboardScreen: true,
          };
          controller.moveToScreen(
              appRout: AppRoutes.editWidgetScreen, arguments: arguments);
        },
        child: Container(
          width: 140,
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageUtils.setSvgAssetsImage(
                  path: Drawable.editWidgetIcon,
                  // path: Drawable.truckPermissionIcon,
                  width: 20,
                  height: 20,
                  color: null),
              SizedBox(
                width: 10,
              ),
              PrimaryTextView(
                text: 'edit_widget'.tr,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                textAlign: TextAlign.center,
                color: primaryTextColorLight_(context),
                softWrap: true,
                maxLine: 2,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
