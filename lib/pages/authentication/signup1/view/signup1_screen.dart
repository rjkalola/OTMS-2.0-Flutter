import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/otp_view.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/firstname_lastname_textfield_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/next_button_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/phone_extension_field_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/phone_text_field_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/photo_upload_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class SignUp1Screen extends StatefulWidget {
  const SignUp1Screen({super.key});

  @override
  State<SignUp1Screen> createState() => _SignUp1ScreenState();
}

class _SignUp1ScreenState extends State<SignUp1Screen> {
  final controller = Get.put(SignUp1Controller());

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
          //   title: ''.tr,
          //   isCenterTitle: true,
          //   isBack: true,
          // ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : SingleChildScrollView(
                        child: Column(children: [
                          Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                const TopDividerWidget(
                                  flex1: 1,
                                  flex2: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 14, 16, 0),
                                  child: HeaderLogo(),
                                ),
                                HeaderTitleNoteTextWidget(
                                  title: 'create_new_account'.tr,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                PhotoUploadWidget(),
                                FirstNameLastNameTextFieldWidget(),
                                SizedBox(
                                  height: 28,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: PhoneExtensionFieldWidget(),
                                    ),
                                    Flexible(
                                        flex: 3, child: PhoneTextFieldWidget()),
                                  ],
                                ),
                                Visibility(
                                  visible: controller.isOtpViewVisible.value,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: OtpView(
                                      mOtpCode: controller.mOtpCode,
                                      otpController: controller.otpController,
                                      timeRemaining:
                                          controller.otmResendTimeRemaining,
                                      onCodeChanged: (code) {
                                        controller.mOtpCode.value =
                                            code.toString();
                                        print("onCodeChanged $code");
                                        if (controller.mOtpCode.value.length ==
                                            6) {
                                          controller.onSubmitClick();
                                        }
                                      },
                                      onResendOtp: () {
                                        print("onResendOtp click");
                                        if (controller.valid()) {
                                          controller.sendOtpApi(
                                              controller.mExtension.value,
                                              controller
                                                  .phoneController.value.text
                                                  .toString()
                                                  .trim());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                NextButtonWidget()
                              ],
                            ),
                          ),
                        ]),
                      ));
          }),
        ),
      ),
    );
  }
}
