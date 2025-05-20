import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/firstname_lastname_textfield_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/next_button_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/phone_extension_field_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/phone_text_field_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/add_company_code_view.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/do_ite_later_text.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/join_company_button.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/create_new_company_button.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/otp_view_join_company.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/select_trade_join_company.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/select_your_role_view.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/text_or.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/widgets/select_company_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class JoinCompanyScreen extends StatefulWidget {
  const JoinCompanyScreen({super.key});

  @override
  State<JoinCompanyScreen> createState() => _JoinCompanyScreenState();
}

class _JoinCompanyScreenState extends State<JoinCompanyScreen> {
  final controller = Get.put(JoinCompanyController());

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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 14, 16, 0),
                              child: HeaderLogo(isBackDisable: true,),
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
                                    controller.mOtpCode.value = code.toString();
                                    print("onCodeChanged $code");
                                  },
                                  onResendOtp: () {
                                    print("onResendOtp click");
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                                visible: controller.isSelectTradeVisible.value,
                                child: SelectTradeJoinCompany())
                            // DoItLater()
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
