import 'package:belcka/pages/users/invite_user/controller/invite_user_controller.dart';
import 'package:belcka/pages/users/invite_user/view/widgets/firstname_lastname_textfield_widget.dart';
import 'package:belcka/pages/users/invite_user/view/widgets/phone_extension_field_widget.dart';
import 'package:belcka/pages/users/invite_user/view/widgets/phone_text_field_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InviteUserScreen extends StatefulWidget {
  const InviteUserScreen({super.key});

  @override
  State<InviteUserScreen> createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {
  final controller = Get.put(InviteUserController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'invite_user'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.loadResources(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(children: [
                          Expanded(
                            child: Form(
                              key: controller.formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FirstNameLastNameTextFieldWidget(),
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: PhoneExtensionFieldWidget(),
                                        ),
                                        Flexible(
                                            flex: 3,
                                            child: PhoneTextFieldWidget()),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 8),
                                      child: DropDownTextField(
                                        title: 'select_trade'.tr,
                                        controller: controller.tradeController,
                                        validators: [
                                          RequiredValidator(
                                              errorText: 'required_field'.tr),
                                        ],
                                        onPressed: () {
                                          controller.showSelectTradeDialog();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 24),
                                      child: DropDownTextField(
                                        title: 'select_team'.tr,
                                        controller: controller.teamController,
                                        validators: [
                                          RequiredValidator(
                                              errorText: 'required_field'.tr),
                                        ],
                                        onPressed: () {
                                          controller.showSelectTeamDialog();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PrimaryButton(
                              padding: EdgeInsets.fromLTRB(14, 18, 14, 20),
                              buttonText: 'invite'.tr,
                              color: defaultAccentColor_(context),
                              onPressed: () {
                                controller.inviteUserClick();
                              })
                        ]),
                      ));
          }),
        ),
      ),
    );
  }
}
