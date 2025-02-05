import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/controller/verify_otp_controller.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/view/widgets/otp_submit_button.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/view/widgets/resend_view_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({
    super.key,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final verifyOtpController = Get.put(VerifyOtpController());

  @override
  void initState() {
    var arguments = Get.arguments;
    if (arguments != null) {
      verifyOtpController.mExtension.value =
          arguments[AppConstants.intentKey.phoneExtension];
      verifyOtpController.mPhoneNumber.value =
          arguments[AppConstants.intentKey.phoneNumber];
      print("verifyOtpController.mExtension:" +
          verifyOtpController.mExtension.value);
      print("verifyOtpController.mPhoneNumber:" +
          verifyOtpController.mPhoneNumber.value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'verify_otp'.tr,
          isCenterTitle: true,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: verifyOtpController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Column(children: [
              Form(
                key: verifyOtpController.formKey,
                child: Expanded(
                  flex: 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 1,
                          height: 1,
                          color: dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 22),
                          child: Text('verify_otp_hint1'.tr,
                              style: const TextStyle(
                                  color: defaultAccentColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Center(
                          child: SizedBox(
                            width: 280,
                            child: PinFieldAutoFill(
                              controller:
                                  verifyOtpController.otpController.value,
                              currentCode: verifyOtpController.mOtpCode.value,
                              keyboardType: TextInputType.number,
                              codeLength: 4,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              autoFocus: true,
                              cursor: Cursor(
                                  color: defaultAccentColor,
                                  enabled: true,
                                  width: 1),
                              decoration: CirclePinDecoration(
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: primaryTextColor),
                                  strokeColorBuilder: PinListenColorBuilder(
                                      Color(0xffc6c6c6), Color(0xffc6c6c6))),
                              onCodeChanged: (code) {
                                print("onCodeChanged $code");
                                verifyOtpController.mOtpCode.value =
                                    code.toString();
                              },
                              onCodeSubmitted: (val) {
                                print("onCodeSubmitted $val");
                              },
                              // enabled: !verifyOtpController.isOtpFilled.value,
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       OtpBoxWidget(
                        //           boxController:
                        //               verifyOtpController.box1.value),
                        //       const SizedBox(
                        //         width: 24,
                        //       ),
                        //       OtpBoxWidget(
                        //           boxController:
                        //               verifyOtpController.box2.value),
                        //       const SizedBox(
                        //         width: 24,
                        //       ),
                        //       OtpBoxWidget(
                        //           boxController:
                        //               verifyOtpController.box3.value),
                        //       const SizedBox(
                        //         width: 24,
                        //       ),
                        //       OtpBoxWidget(
                        //           boxController:
                        //               verifyOtpController.box4.value),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 28,
                        ),
                        ResendViewWidget()
                      ]),
                ),
              ),
              Column(
                children: [
                  Visibility(
                    visible: verifyOtpController.mOtpCode.value.length == 4,
                    child: InkWell(
                      onTap: () {
                        verifyOtpController.resetOtpField();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: PrimaryTextView(
                          text: "Clear Otp",
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  OtpSubmitButton()
                ],
              )
            ]),
          );
        }),
      ),
    );
  }
}
