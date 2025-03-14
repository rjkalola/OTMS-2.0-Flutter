import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/controller/login_controller.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/do_not_have_account_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/login_button_widget.dart';
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
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'login'.tr,
            isCenterTitle: true,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: loginController.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: loginController.isInternetNotAvailable.value
                    ? const Center(
                        child: Text("No Internet"),
                      )
                    : Column(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 1,
                                height: 1,
                                color: dividerColor,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
                              //   child: Text('phone_number'.tr,
                              //       textAlign: TextAlign.start,
                              //       style: const TextStyle(
                              //         color: Colors.black45,
                              //         fontSize: 12,
                              //       )),
                              // ),
                              const SizedBox(
                                height: 50,
                              ),
                              Form(
                                key: loginController.formKey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      child: PhoneExtensionFieldWidget(),
                                    ),
                                    Flexible(
                                        flex: 9, child: PhoneTextFieldWidget()),
                                  ],
                                ),
                              ),
                              LoginButtonWidget()
                            ],
                          ),
                        ),
                        DoNotHaveAnAccountWidget(),
                        SignUpTextWidget()
                      ]));
          }),
        ),
      ),
    );
  }
}
