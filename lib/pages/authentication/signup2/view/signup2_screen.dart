import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:otm_inventory/pages/authentication/signup2/controller/signup2_controller.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/camera_icon_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/preferred_image_size_text_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/register_button_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/sign_up2_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/upload_photo_text_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class SignUp2Screen extends StatefulWidget {
  const SignUp2Screen({super.key});

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  final controller = Get.put(SignUp2Controller());

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
                  : Column(
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
    );
  }
}
