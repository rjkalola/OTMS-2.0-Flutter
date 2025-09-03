import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/view/widgets/more_tab_buttons.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';

import '../../../../res/colors.dart';
import '../../../../utils/AlertDialogHelper.dart';
import '../../../common/listener/DialogButtonClickListener.dart';
import '../../controller/dashboard_controller.dart';

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
   AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      // appBar: AppBar(
      //   surfaceTintColor: Colors.transparent,
      //   leadingWidth: 32, // <-- Use this- and this
      //   title: Text('more'.tr,
      //       style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      // ),
      body: Column(
        children: [
           Divider(
            thickness: 1,
            height: 1,
            color: dividerColor_(context),
          ),
          const SizedBox(
            height: 6,
          ),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(children: [
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
                          false,
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

  Widget divider() =>  Padding(
        padding: EdgeInsets.only(left: 18, right: 20),
        child: Divider(thickness: 0.4, height: 0.4, color: dividerColor_(context)),
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
      // dashboardController.logoutAPI();
      Get.find<AppStorage>().clearAllData();
      Get.offAllNamed(AppRoutes.introductionScreen);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}
}
