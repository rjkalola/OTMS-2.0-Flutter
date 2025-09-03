import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:belcka/pages/authentication/other_info_steps/step1_team_users_count_info/view/widgets/team_users_count_items_list.dart';
import 'package:belcka/pages/authentication/other_info_steps/step2_business_field_info/controller/business_field_info_controller.dart';
import 'package:belcka/pages/authentication/other_info_steps/step2_business_field_info/view/widgets/business_field_info_items_list.dart';
import 'package:belcka/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:belcka/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/buttons/ContinueButton.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/utils/app_utils.dart';

class BusinessFieldInfoScreen extends StatefulWidget {
  BusinessFieldInfoScreen({super.key});

  @override
  State<BusinessFieldInfoScreen> createState() =>
      _BusinessFieldInfoScreenState();
}

class _BusinessFieldInfoScreenState extends State<BusinessFieldInfoScreen> {
  final controller = Get.put(BusinessFieldInfoController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getCompanyResourcesApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                const TopDividerWidget(
                                  flex1: 5,
                                  flex2: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 14, 16, 0),
                                  child: HeaderLogo(),
                                ),
                                HeaderTitleNoteTextWidget(
                                  title:
                                      'which_field_best_describe_your_business'
                                          .tr,
                                ),
                                BusinessFieldInfoItemsList(),
                                Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 16, 20, 16),
                                    width: double.infinity,
                                    child: ContinueButton(onPressed: () {
                                      controller.onClickContinueButton();
                                    }))
                              ],
                            ),
                          ]),
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
