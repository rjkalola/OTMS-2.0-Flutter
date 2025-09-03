import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/introduction/controller/introduction_controller.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/app_logo_widget.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/create_new_account_widget_.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/header_widget.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/login_button_widget.dart';
import 'package:belcka/pages/authentication/introduction/view/widgets/login_users_list.dart';

import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';

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
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Divider(
              thickness: 1,
              height: 1,
              color: dividerColor_(context),
            ),
            HeaderWidget(),
            AppLogoWidget(),
            const SizedBox(
              height: 35,
            ),
            Expanded(child: LoginUsersList()),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Divider(
                thickness: 1,
                height: 1,
                color: dividerColor_(context),
              ),
            ),
            CreateNewAccount(),
            LoginButtonWidget(),
            // SelectUrl()
          ]),
        ),
      ),
    );
  }
}
