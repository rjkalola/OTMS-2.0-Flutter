import 'package:belcka/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:belcka/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:belcka/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/pages/company/joincompany/view/widgets/back_logo_join_company.dart';
import 'package:belcka/pages/company/joincompany/view/widgets/create_new_company_button.dart';
import 'package:belcka/pages/company/joincompany/view/widgets/join_company_button.dart';
import 'package:belcka/pages/company/joincompany/view/widgets/otp_view_join_company.dart';
import 'package:belcka/pages/company/joincompany/view/widgets/select_trade_join_company.dart';
import 'package:belcka/pages/company/joincompany/view/widgets/text_or.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class JoinCompanyScreen extends StatefulWidget {
  const JoinCompanyScreen({super.key});

  @override
  State<JoinCompanyScreen> createState() => _JoinCompanyScreenState();
}

class _JoinCompanyScreenState extends State<JoinCompanyScreen>
    implements DialogButtonClickListener {
  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor_(context),
            // appBar: BaseAppBar(
            //   appBar: AppBar(),
            //   title: 'join_company'.tr,
            //   isCenterTitle: false,
            //   isBack: false,
            // ),
            body: Obx(() {
              return ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? const NoInternetWidget()
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              const TopDividerWidget(
                                flex1: 2,
                                flex2: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BackLogoJoinCompany(),
                                  GestureDetector(
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
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 9, 16, 9),
                                      child: TitleTextView(
                                        text: 'logout'.tr,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              HeaderTitleNoteTextWidget(
                                title: 'create_or_join_company'.tr,
                              ),
                              // SelectCompanyView(),
                              // TextOr(),
                              // AddCompanyCode(),
                              // TextOr(),
                              CreateNewCompanyButton(),
                              TextOr(),
                              JoinCompanyButton(),
                              // SelectYourRoleView(),
                              Visibility(
                                visible: controller.isOtpViewVisible.value,
                                child: Padding(
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
                                        controller.joinCompanyApi();
                                      }
                                      print("onCodeChanged $code");
                                    },
                                    onResendOtp: () {
                                      print("onResendOtp click");
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible:
                                      controller.isSelectTradeVisible.value,
                                  child: SelectTradeJoinCompany())
                              // DoItLater()
                            ],
                          ),
                        ));
            }),
          ),
        ),
      ),
    );
  }

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
