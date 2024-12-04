import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import '../../../../res/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/AlertDialogHelper.dart';
import '../../../../utils/app_storage.dart';
import '../../../common/listener/DialogButtonClickListener.dart';
import '../../widgets/more_tab_buttons.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileTabState();
  }
}

class ProfileTabState extends State<ProfileTab> implements DialogButtonClickListener {
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
      //   title: Text('profile'.tr,
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

                ]),
              )),
        ],
      ),
    );
  }

  Widget divider() => const Padding(
        padding: EdgeInsets.only(left: 18, right: 20),
        child: Divider(thickness: 0.4, height: 0.4, color: dividerColor),
      );

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      Navigator.of(context).pop(); //
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.logout) {
      Get.find<AppStorage>().clearAllData();
      // Navigator.of(context).pop(); //
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {

  }
}
