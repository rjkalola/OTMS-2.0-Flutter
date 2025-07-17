import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:otm_inventory/pages/authentication/signup2/controller/signup2_controller.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/camera_icon_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/preferred_image_size_text_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/register_button_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/sign_up2_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/widgets/upload_photo_text_widget.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/action_buttons_company_sign_up.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/company_name_textfield.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/currency_textfield_company_sign_up.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/head_office_location_view_company_signup.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/phone_number_view_company_sign_up.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/preferred_image_size_view.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/toolbar_divider_company_signup.dart';
import 'package:otm_inventory/pages/company/company_signup/view/widgets/upload_photo_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/utils/app_utils.dart';
class CompanySignUpScreen extends StatefulWidget {
  const CompanySignUpScreen({super.key});

  @override
  State<CompanySignUpScreen> createState() => _CompanySignUpScreenState();
}

class _CompanySignUpScreenState extends State<CompanySignUpScreen> {
  final controller = Get.put(CompanySignUpController());

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
              title: 'company_details'.tr,
              isCenterTitle: false,
              isBack: false,
              widgets: actionButtons()),
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
                              child: ToolbarDividerCompanySignup(),
                            ),
                            Form(
                              key: controller.formKey,
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UploadPhotoView(),
                                      PreferredImageSizeView(),
                                      SizedBox(
                                        height: 26,
                                      ),
                                      Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: dividerColor_(context)),
                                      CompanyNameTextField(),
                                      PhoneNumberViewCompanySignUp(),
                                      HeadOfficeLocationViewCompanySignup(),
                                      CurrencyTextFieldCompanySignUp()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ActionButtonsCompanySignUp()
                            // RegisterButtonWidget()
                          ]));
          }),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconButton(
          icon: SvgPicture.asset(Drawable.scanQrCodeIcon, width: 22),
          onPressed: () {},
        ),
      ),
    ];
  }
}
