import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/teams/join_team_to_company/view/widgets/otp_view_join_company.dart';
import 'package:belcka/pages/teams/join_team_to_company/controller/join_team_to_company_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class JoinTeamToCompanyScreen extends StatefulWidget {
  const JoinTeamToCompanyScreen({super.key});

  @override
  State<JoinTeamToCompanyScreen> createState() =>
      _JoinTeamToCompanyScreenState();
}

class _JoinTeamToCompanyScreenState extends State<JoinTeamToCompanyScreen> {
  final controller = Get.put(JoinTeamToCompanyController());

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
            title: 'join_a_company'.tr,
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
                    ? const NoInternetWidget()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                            child: OtpViewJoinCompany(
                              mOtpCode: controller.mOtpCode,
                              otpController: controller.otpController,
                              onCodeChanged: (code) {
                                controller.mOtpCode.value = code.toString();
                                if (controller.mOtpCode.value.length == 6) {
                                  controller.addTeamToCompanyApi();
                                }
                                print("onCodeChanged $code");
                              },
                              onResendOtp: () {
                                print("onResendOtp click");
                              },
                            ),
                          ),
                          /*  Visibility(
                            visible: controller.isSelectTradeVisible.value,
                            child: SelectTradeJoinCompany())*/
                        ],
                      ));
          }),
        ),
      ),
    );
  }
}
