import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/teams/team_generate_otp/controller/team_generate_otp_controller.dart';
import 'package:belcka/pages/teams/team_generate_otp/view/widgets/generate_otp_view.dart';
import 'package:belcka/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:belcka/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:belcka/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class TeamGenerateOtpScreen extends StatefulWidget {
  const TeamGenerateOtpScreen({super.key});

  @override
  State<TeamGenerateOtpScreen> createState() => _TeamGenerateOtpScreenState();
}

class _TeamGenerateOtpScreenState extends State<TeamGenerateOtpScreen> {
  final controller = Get.put(TeamGenerateOtpController());

  @override
  Widget build(BuildContext context) {
      AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'generate_code'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
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
                                timeRemaining:
                                    controller.otmResendTimeRemaining,
                                onCodeChanged: (code) {
                                  controller.mOtpCode.value = code.toString();
                                  print("onCodeChanged $code");
                                },
                                onResendOtp: () {
                                  controller.teamGenerateOtpApi();
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
