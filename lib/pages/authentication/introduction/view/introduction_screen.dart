import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/introduction/controller/introduction_controller.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/app_logo_widget.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/create_new_account_widget_.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/header_widget.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/img_introduction_image1.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/login_button_widget.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/login_users_list.dart';
import 'package:belcka/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';

import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final controller = Get.put(IntroductionController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          body: Column(
            children: [
              SizedBox(
                height: 40,
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
                        height: 26,
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
