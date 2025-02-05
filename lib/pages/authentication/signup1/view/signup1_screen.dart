import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/login_button_widget.dart';
import 'package:otm_inventory/pages/authentication/login/controller/login_controller.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/do_not_have_account_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/phone_extension_field_widget.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/phone_text_field_widget.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/sign_up_text_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/firstname_lastname_textfield_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/next_button_widget.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/sign_up_note_text_widget_.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: ''.tr,
          isCenterTitle: true,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? const NoInternetWidget()
                  : Column(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Divider(
                                thickness: 0.5,
                                height: 0.5,
                                color: defaultAccentColor,
                              ),
                            ),
                            const TopDividerWidget(),
                            const SignUpNoteTextWidget(),
                            FirstNameLastNameTextFieldWidget(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                              child: Text('phone_number'.tr,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                  )),
                            ),
                            Form(
                              key: controller.formKey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  PhoneExtensionFieldWidget(),
                                  PhoneTextFieldWidget(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const NextButtonWidget()
                    ]));
        }),
      ),
    );
  }
}
