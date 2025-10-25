import 'package:belcka/pages/authentication/update_sign_up_details/controller/update_sign_up_details_controller.dart';
import 'package:belcka/pages/authentication/update_sign_up_details/view/widgets/firstname_lastname_textfield_widget.dart';
import 'package:belcka/pages/authentication/update_sign_up_details/view/widgets/next_button_widget.dart';
import 'package:belcka/pages/authentication/update_sign_up_details/view/widgets/phone_extension_field_widget.dart';
import 'package:belcka/pages/authentication/update_sign_up_details/view/widgets/phone_text_field_widget.dart';
import 'package:belcka/pages/authentication/update_sign_up_details/view/widgets/photo_upload_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UpdateSignUpDetailsScreen extends StatefulWidget {
  const UpdateSignUpDetailsScreen({super.key});

  @override
  State<UpdateSignUpDetailsScreen> createState() =>
      _UpdateSignUpDetailsScreenState();
}

class _UpdateSignUpDetailsScreenState extends State<UpdateSignUpDetailsScreen> {
  final controller = Get.put(UpdateSignUpDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'update_details'.tr,
              isCenterTitle: false,
              isBack: false,
              bgColor: dashBoardBgColor_(context),
              onBackPressed:(){
                controller.onBackPress();
              } ,
            ),
            body: Obx(() {
              return ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? const NoInternetWidget()
                      : SingleChildScrollView(
                          child: Column(children: [
                            Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  PhotoUploadWidget(),
                                  FirstNameLastNameTextFieldWidget(),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  NextButtonWidget()
                                ],
                              ),
                            ),
                          ]),
                        ));
            }),
          ),
        ),
      ),
    );
  }
}
