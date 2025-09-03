import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:belcka/pages/authentication/signup2/controller/signup2_controller.dart';
import 'package:belcka/pages/authentication/signup2/view/widgets/camera_icon_widget.dart';
import 'package:belcka/pages/authentication/signup2/view/widgets/preferred_image_size_text_widget.dart';
import 'package:belcka/pages/authentication/signup2/view/widgets/register_button_widget.dart';
import 'package:belcka/pages/authentication/signup2/view/widgets/sign_up2_note_text_widget_.dart';
import 'package:belcka/pages/authentication/signup2/view/widgets/top_divider_widget.dart';
import 'package:belcka/pages/authentication/signup2/view/widgets/upload_photo_text_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/utils/app_utils.dart';
class SignUp2Screen extends StatefulWidget {
  const SignUp2Screen({super.key});

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  final controller = Get.put(SignUp2Controller());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
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
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Divider(
                                thickness: 0.5,
                                height: 0.5,
                                color: defaultAccentColor_(context),
                              ),
                            ),
                            const TopDividerWidget(),
                            const SignUp2NoteTextWidget(),
                            Expanded(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CameraIconWidget(),
                                    UploadPhotoTextWidget(),
                                    PreferredImageSizeTextWidget()
                                  ],
                                ),
                              ),
                            ),
                            RegisterButtonWidget()
                          ]));
          }),
        ),
      ),
    );
  }
}
