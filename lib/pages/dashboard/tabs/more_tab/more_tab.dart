import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_constants.dart';

import '../../../../res/colors.dart';
import '../../../../utils/AlertDialogHelper.dart';
import '../../../common/listener/DialogButtonClickListener.dart';
import '../../dashboard_controller.dart';
import '../../widgets/more_tab_buttons.dart';

class MoreTab extends StatefulWidget {
  MoreTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return MoreTabState();
  }
}

class MoreTabState extends State<MoreTab> implements DialogButtonClickListener {
  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   surfaceTintColor: Colors.transparent,
      //   leadingWidth: 32, // <-- Use this- and this
      //   title: Text('more'.tr,
      //       style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      // ),
      body: Column(
        children: [
          const Divider(
            thickness: 1,
            height: 1,
            color: dividerColor,
          ),
          const SizedBox(
            height: 6,
          ),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(children: [
                  MoreTabButton(
                      iconPadding: 0,
                      iconPath: Drawable.settingsIcon,
                      mText: 'settings'.tr,
                      onPressed: () {}),
                  divider(),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(23, 18, 14, 18),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'logout'.tr,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    onTap: () {
                      AlertDialogHelper.showAlertDialog(
                          "",
                          'logout_msg'.tr,
                          'yes'.tr,
                          'no'.tr,
                          "",
                          true,
                          this,
                          AppConstants.dialogIdentifier.logout);
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  )
                ]),
              )),
        ],
      ),
    );
  }

  Widget divider() =>
      const Padding(
        padding: EdgeInsets.only(left: 18, right: 20),
        child: Divider(thickness: 0.4, height: 0.4, color: dividerColor),
      );

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      Get.back();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      dashboardController.logoutAPI();
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {

  }
}
