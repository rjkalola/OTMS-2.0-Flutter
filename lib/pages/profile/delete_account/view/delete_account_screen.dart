import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:belcka/pages/authentication/login/view/widgets/log_in_note1_text_widget_.dart';
import 'package:belcka/pages/authentication/login/view/widgets/log_in_note2_text_widget_.dart';
import 'package:belcka/pages/authentication/login/view/widgets/otp_view.dart';
import 'package:belcka/pages/authentication/otp_verification/view/widgets/otp_submit_button.dart';
import 'package:belcka/pages/authentication/otp_verification/view/widgets/resend_view_widget.dart';
import 'package:belcka/pages/profile/delete_account/controller/delete_account_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../authentication/introduction/view/widgets/login_button_widget.dart';
import '../../../authentication/login/view/widgets/phone_extension_field_widget.dart';
import 'package:belcka/utils/app_utils.dart';
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({
    super.key,
  });

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final controller = Get.put(DeleteAccountController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: Scaffold(
        backgroundColor: backgroundColor_(context),
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'delete_account'.tr,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? Center(
              child: Text("no_internet_text".tr),
            )
                : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: controller.isOtpViewVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: OtpView(
                          mOtpCode: controller.mOtpCode,
                          otpController: controller.otpController,
                          timeRemaining:
                          controller.otmResendTimeRemaining,
                          onCodeChanged: (code) {
                            controller.mOtpCode.value = code ?? "";
                            print("onCodeChanged $code");
                            if (controller.mOtpCode.value.length ==
                                6) {
                              controller.onSubmitClick();
                            }
                          },
                          onResendOtp: () {
                            controller.sendOtpApi();
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible:controller.isOtpViewVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                                buttonText: 'delete_account'.tr,
                                onPressed: () {
                                  if (controller.mOtpCode.value.length ==
                                      6) {
                                    controller.onSubmitClick();
                                  }
                                }
                                )
                        ),
                      ),
                    )
                  ],
                )),
          );
        }),
      ),
    );
  }
}