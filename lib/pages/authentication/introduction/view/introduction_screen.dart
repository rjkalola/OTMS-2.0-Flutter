import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/introduction/controller/introduction_controller.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/app_logo_widget.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/create_new_account_widget_.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/header_widget.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/img_introduction_image1.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/login_button_widget.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/login_users_list.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';

import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final controller = Get.put(IntroductionController());

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
          body: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              AppLogoWidget(),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Divider(
                      //   thickness: 1,
                      //   height: 1,
                      //   color: dividerColor,
                      // ),
                      // HeaderWidget(),
                      ImgIntroductionImage1(),
                      SizedBox(
                        height: 10,
                      ),
                      HeaderTitleNoteTextWidget(
                        fontSize: 24,
                        title: 'first_screen_welcome_title'.tr,
                        textAlign: TextAlign.center,
                      ),
                      PrimaryTextView(
                        text: 'first_screen_note'.tr,
                        textAlign: TextAlign.center,
                      ),
                      // Expanded(child: LoginUsersList()),
                      const SizedBox(
                        height: 30,
                      ),
                      LoginButtonWidget(),
                      CreateNewAccount(),
                      // SelectUrl()
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
