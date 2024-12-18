import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/login/controller/login_controller.dart';
import 'package:otm_inventory/pages/login/view/widgets/login_button_widget.dart';
import 'package:otm_inventory/pages/login/view/widgets/login_users_list.dart';
import 'package:otm_inventory/pages/login/view/widgets/phone_extension_field_widget.dart';
import 'package:otm_inventory/pages/login/view/widgets/phone_text_field_widget.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../res/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

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
          title: 'login'.tr,
          isCenterTitle: true,
          isBack: false,
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
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Divider(
                            thickness: 1,
                            height: 1,
                            color: dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
                            child: Text('phone_number'.tr,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                )),
                          ),
                          Form(
                            key: loginController.formKey,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                PhoneExtensionFieldWidget(),
                                PhoneTextFieldWidget(),
                              ],
                            ),
                          ),
                          LoginButtonWidget(),
                          const SizedBox(
                            height: 20,
                          ),
                          LoginUsersList()
                        ]));
        }),
      ),
    );
  }
}
