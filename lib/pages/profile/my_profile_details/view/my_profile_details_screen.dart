import 'package:belcka/pages/authentication/login/view/widgets/otp_view.dart';
import 'package:belcka/pages/authentication/login/view/widgets/phone_extension_field_widget.dart';
import 'package:belcka/pages/authentication/login/view/widgets/phone_text_field_widget.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/title_text.dart';
import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/email_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/first_name_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/last_name_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/phone_extension_field.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/phone_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/profile_avatar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyProfileDetailsScreen extends StatefulWidget {
  const MyProfileDetailsScreen({super.key});
  @override
  State<MyProfileDetailsScreen> createState() => _MyProfileDetailsScreenState();
}

class _MyProfileDetailsScreenState extends State<MyProfileDetailsScreen> {
  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "",
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ?  Center(
              child: Text('no_internet_text'.tr),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //profile UI
                                Container(
                                  padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Avatar
                                      ProfileAvatarWidget(),
                                      SizedBox(height: 10),
                                      // trade
                                      Text(
                                        controller.myProfileInfo.value.tradeName ?? "",
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 10),
                                      CardViewDashboardItem(
                                          margin: EdgeInsets.fromLTRB(4, 6, 4, 6),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TitleText(
                                                  title: 'general'.tr,
                                                ),
                                                SizedBox(height: 14,),
                                                Row(children: [
                                                  Flexible(flex: 1, child: FirstNameFieldWidget(

                                                  )),
                                                  SizedBox(
                                                    width: 14,
                                                  ),
                                                  Flexible(flex: 1, child: LastNameFieldWidget(

                                                  ))
                                                ]),
                                                SizedBox(height: 16,),
                                                GestureDetector(
                                                  onTap: (){
                                                    AppUtils.onClickPhoneNumber(controller.phoneController.value.text ?? "");
                                                  },
                                                  child: PhoneFieldWidget(

                                                  ),
                                                ),
                                                SizedBox(height: 16,),
                                                GestureDetector(
                                                  onTap: (){
                                                    if ((controller.emailController.value.text ?? "").isNotEmpty){
                                                      AppUtils.copyEmail(controller.emailController.value.text ?? "");
                                                    }
                                                  },
                                                    child: EmailFieldWidget(

                                                    )),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                )),
          ),
        ),
      ),
    ),);
  }
}