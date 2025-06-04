import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/controller/login_controller.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/do_not_have_account_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/log_in_note1_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/log_in_note2_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/login_button_widget.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/otp_view.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/phone_extension_field_widget.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/phone_text_field_widget.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/sign_up_text_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    /* Future.delayed(Duration(milliseconds: 2000)).then(
            (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        )));*/
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
          //   title: 'login'.tr,
          //   isCenterTitle: true,
          //   isBack: true,
          // ),
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: loginController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: loginController.isInternetNotAvailable.value
                  ? const Center(
                      child: Text("No Internet"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   height: 50,
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
                          child: HeaderLogo(),
                        ),
                        LogInNote1TextWidget(),
                        LogInNote2TextWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: loginController.formKey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 2,
                                child: PhoneExtensionFieldWidget(),
                              ),
                              Flexible(flex: 3, child: PhoneTextFieldWidget()),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: loginController.isOtpViewVisible.value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: OtpView(
                              mOtpCode: loginController.mOtpCode,
                              otpController: loginController.otpController,
                              timeRemaining:
                                  loginController.otmResendTimeRemaining,
                              onCodeChanged: (code) {
                                loginController.mOtpCode.value = code ?? "";
                                print("onCodeChanged $code");
                                if (loginController.mOtpCode.value.length ==
                                    6) {
                                  loginController.login();
                                }
                              },
                              onResendOtp: () {
                                if (loginController.valid(false)) {
                                  loginController.sendOtpApi();
                                }
                              },
                            ),
                          ),
                        ),
                        LoginButtonWidget()
                      ],
                    )),
            );
          }),
        ),
      ),
    );
  }
}
