import 'package:belcka/pages/dashboard/tabs/more_tab/controller/more_tab_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/AlertDialogHelper.dart';

class MoreTab extends StatefulWidget {
  MoreTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return MoreTabState();
  }
}

class MoreTabState extends State<MoreTab> {
  final controller = Get.put(MoreTabController());

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
      body: ModalProgressHUD(
        inAsyncCall: controller.isLoading.value,
        opacity: 0,
        progressIndicator: const CustomProgressbar(),
        child: Column(
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
                        controller.showLogoutDialog();
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    )
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  Widget divider() => Padding(
        padding: EdgeInsets.only(left: 18, right: 20),
        child:
            Divider(thickness: 0.4, height: 0.4, color: dividerColor_(context)),
      );
}
