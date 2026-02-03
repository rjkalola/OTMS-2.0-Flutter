import 'package:belcka/pages/authentication/login/view/widgets/otp_view.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/view/widgets/personal_info_screen_section_card.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final controller = Get.put(PersonalInfoController());

  KeyboardActionsConfig _buildKeyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: controller.focusNode,
          toolbarButtons: [
                (node) => TextButton(
              onPressed: () => node.unfocus(),
              child: Text(
                'done'.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0.3,
          progressIndicator: const CustomProgressbar(),
          child: Container(
            color: dashBoardBgColor_(context),
            child: SafeArea(
              child: Scaffold(
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'Personal Details'.tr,
                  isCenterTitle: false,
                  bgColor: dashBoardBgColor_(context),
                  isBack: true,
                  onBackPressed: (){
                    controller.onBackPress();
                  },
                ),
                backgroundColor: dashBoardBgColor_(context),
                body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  onPanDown: (_) => FocusScope.of(context).unfocus(),
                  child: KeyboardActions(
                    config: _buildKeyboardConfig(),
                    child: controller.isInternetNotAvailable.value
                        ? Center(child: Text("no_internet_text".tr))
                        : Visibility(
                      visible: controller.isMainViewVisible.value,
                          child: SingleChildScrollView(
                                              keyboardDismissBehavior:
                                              ScrollViewKeyboardDismissBehavior.onDrag,
                                              physics: const BouncingScrollPhysics(),
                                              child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PersonalInfoSectionCard(isEnabled: !controller.isOtpViewVisible.value
                                  && (UserUtils.isLoginUser(controller.userId)),),
                              Visibility(
                                visible: controller.isOtpViewVisible.value,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: OtpView(
                                    mOtpCode: controller.mOtpCode,
                                    otpController: controller.otpController,
                                    timeRemaining:
                                    controller.otmResendTimeRemaining,
                                    onCodeChanged: (code) {
                                      controller.mOtpCode.value = code ?? "";
                                      print("onCodeChanged $code");
                                      if (controller.mOtpCode.value.length ==
                                          6) {
                                        controller.onClickVerifyOTP();
                                      }
                                    },
                                    onResendOtp: () {
                                      controller.sendOtpApi();
                                    },
                                  ),
                                ),
                              ),

                              //Update button
                              Visibility(
                                visible: controller.isShowSaveButton.value,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Obx(() {
                                    final enabled = controller.isSaveEnabled.value;
                                    return Opacity(
                                      opacity: enabled ? 1.0 : 0.5,
                                      child: ElevatedButton(
                                        onPressed: enabled ? controller.submitAction : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: defaultAccentColor_(context),
                                          minimumSize: const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          'update'.tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              )
                            ],
                          ),
                                              ),
                                            ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
