import 'package:belcka/pages/profile/rates/view/widgets/rate_request_pending_for_approval.dart';
import 'package:belcka/pages/profile/rates/view/widgets/trade_view.dart';
import 'package:belcka/pages/profile/user_code/controller/user_code_controller.dart';
import 'package:belcka/pages/profile/user_code/view/widgets/user_code_text_field.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/rates/view/widgets/netPer_text_field.dart';
import 'package:belcka/pages/profile/rates/view/widgets/trade_select_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class UserCodeScreen extends StatefulWidget {
  const UserCodeScreen({super.key});

  @override
  State<UserCodeScreen> createState() => _UserCodeScreenState();
}

class _UserCodeScreenState extends State<UserCodeScreen> {
  final controller = Get.put(UserCodeController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
            color: dashBoardBgColor_(context),
            child: SafeArea(
              child: Scaffold(
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: "user_code".tr,
                  isCenterTitle: false,
                  bgColor: dashBoardBgColor_(context),
                  isBack: true,
                  onBackPressed: () {
                    controller.onBackPress();
                  },
                ),
                backgroundColor: dashBoardBgColor_(context),
                body: ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? Center(
                          child: Text("no_internet_text".tr),
                        )
                      : Visibility(
                    visible: controller.isMainViewVisible.value,
                        child: SingleChildScrollView(
                            child: CardViewDashboardItem(
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: 8),
                                UserCodeTextField(),
                                SizedBox(height: 32),

                                Obx(() {
                                  final enabled = controller.isSaveEnabled.value;
                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Opacity(
                                      opacity: enabled ? 1.0 : 0.4,
                                      child: ElevatedButton(
                                        onPressed: enabled
                                            ? () {
                                                FocusScope.of(context).unfocus();
                                                controller.updateProfileAPI();
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              defaultAccentColor_(context),
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          'save'.tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )),
                      ),
                ),
                // This is where bottomNavigationBar should go
              ),
            ),
          )),
    );
  }
}
