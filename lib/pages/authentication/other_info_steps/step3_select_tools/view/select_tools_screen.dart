import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step2_business_field_info/view/widgets/business_field_info_items_list.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step3_select_tools/controller/select_tools_controller.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step3_select_tools/view/widgets/select_tool_items_list.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/utils/app_utils.dart';
class SelectToolsScreen extends StatefulWidget {
  SelectToolsScreen({super.key});

  @override
  State<SelectToolsScreen> createState() => _SelectToolsScreenState();
}

class _SelectToolsScreenState extends State<SelectToolsScreen> {
  final controller = Get.put(SelectToolsController());

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
                                  flex1: 6,
                                  flex2: 0,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 14, 16, 0),
                                  child: HeaderLogo(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 0, left: 20, right: 20),
                                  child: Text('business_field_info_note1'.tr,
                                      style:  TextStyle(
                                        color: primaryTextColor_(context),
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6, bottom: 0, left: 20, right: 20),
                                  child: PrimaryTextView(
                                    text: 'business_field_info_note2'.tr,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryTextColor_(context),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18, bottom: 0, left: 20, right: 20),
                                  child: Text('operations'.tr,
                                      style:  TextStyle(
                                        color: primaryTextColor_(context),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                SelectToolItemsList(),
                                Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 16, 20, 16),
                                    width: double.infinity,
                                    child: ContinueButton(
                                        title: 'finish'.tr,
                                        onPressed: () {
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
