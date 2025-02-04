import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/introduction/controller/introduction_controller.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/app_logo_widget.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/create_new_account_widget_.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/header_widget.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/login_button_widget.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/login_users_list.dart';

import 'package:otm_inventory/res/colors.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Divider(
            thickness: 1,
            height: 1,
            color: dividerColor,
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
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Divider(
              thickness: 1,
              height: 1,
              color: dividerColor,
            ),
          ),
          CreateNewAccount(),
          LoginButtonWidget(),
          // SelectUrl()
        ]),
      ),
    );
  }
}
