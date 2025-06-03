import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/controller/team_generate_otp_controller.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/view/widgets/generate_otp_view.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class TeamGenerateOtpScreen extends StatefulWidget {
  const TeamGenerateOtpScreen({super.key});

  @override
  State<TeamGenerateOtpScreen> createState() => _TeamGenerateOtpScreenState();
}

class _TeamGenerateOtpScreenState extends State<TeamGenerateOtpScreen> {
  final controller = Get.put(TeamGenerateOtpController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'generate_code'.tr,
            isCenterTitle: false,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.teamGenerateOtpApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 50, 20, 10),
                              child: GenerateOtpView(
                                mOtpCode: controller.mOtpCode,
                                otpController: controller.otpController,
                                onCodeChanged: (code) {
                                  controller.mOtpCode.value = code.toString();
                                  print("onCodeChanged $code");
                                },
                                onResendOtp: () {
                                  print("onResendOtp click");
                                },
                              ),
                            )
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
