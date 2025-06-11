import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/pages/teams/generate_company_code/controller/generate_company_code_controller.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/controller/team_generate_otp_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:sms_autofill/sms_autofill.dart';

class GenerateOtpView extends StatelessWidget {
  GenerateOtpView(
      {super.key,
      required this.otpController,
      this.mOtpCode,
      required this.onCodeChanged,
      required this.onResendOtp,
      this.timeRemaining});

  final Rx<TextEditingController> otpController;
  final RxString? mOtpCode;
  final Function(String?) onCodeChanged;
  final RxInt? timeRemaining;

  // final VoidCallback onResendOtp;
  final GestureTapCallback onResendOtp;
  final controller = Get.put(GenerateCompanyCodeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: AppUtils.getGrayBorderDecoration(
          borderColor: Colors.grey.shade300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 6,
            ),
            PrimaryTextView(
              text: 'random_code_generator'.tr,
              fontSize: 18,
              color: primaryTextColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: PinFieldAutoFill(
                  enabled: false,
                  controller: otpController.value,
                  currentCode: mOtpCode?.value ?? "",
                  keyboardType: TextInputType.number,
                  codeLength: 6,
                  inputFormatters: <TextInputFormatter>[
                    // for below version 2 use this
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  autoFocus: false,
                  cursor: Cursor(
                      color: defaultAccentColor, enabled: true, width: 1),
                  decoration: BoxLooseDecoration(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor),
                    strokeColorBuilder: PinListenColorBuilder(
                        Color(0xffc6c6c6), Color(0xffc6c6c6)),
                  ),
                  onCodeChanged: (code) {
                    // print("onCodeChanged::: $code");
                    onCodeChanged(code.toString());
                    // verifyOtpController.mOtpCode.value = code.toString();
                  },
                  onCodeSubmitted: (val) {
                    print("onCodeSubmitted $val");
                  },
                  // enabled: !verifyOtpController.isOtpFilled.value,
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            PrimaryTextView(
              text:
                  "${'resend_code_in'.tr} ${DateUtil.seconds_To_MM_SS(timeRemaining!.value)}",
              fontSize: 16,
              color: primaryTextColor,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                AppUtils.copyText(mOtpCode?.value ?? "");
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 16,
                      color: secondaryTextColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    PrimaryTextView(
                      text: 'copy_code'.tr,
                      fontSize: 15,
                      color: secondaryTextColor,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "${'generate_password'.tr}, ",
                  style: const TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                        text: "${'again'.tr.toLowerCase()}?",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (timeRemaining?.value == 0) onResendOtp();
                          },
                        style: TextStyle(
                            fontSize: 16,
                            color: timeRemaining?.value == 0
                                ? defaultAccentColor
                                : secondaryTextColor,
                            fontWeight: FontWeight.w500)),
                  ],
                )),
            SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
