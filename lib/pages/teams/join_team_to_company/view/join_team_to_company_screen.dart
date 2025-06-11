import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/teams/join_team_to_company/view/widgets/otp_view_join_company.dart';
import 'package:otm_inventory/pages/teams/join_team_to_company/controller/join_team_to_company_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'join_a_company'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor,
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
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 30, 20, 10),
                                  child: OtpViewJoinCompany(
                                    mOtpCode: controller.mOtpCode,
                                    otpController: controller.otpController,
                                    onCodeChanged: (code) {
                                      controller.mOtpCode.value =
                                          code.toString();
                                      if (controller.mOtpCode.value.length ==
                                          6) {
                                        controller.addTeamToCompanyApi();
                                      }
                                      print("onCodeChanged $code");
                                    },
                                    onResendOtp: () {
                                      print("onResendOtp click");
                                    },
                                  ),
                                )
                              ],
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
