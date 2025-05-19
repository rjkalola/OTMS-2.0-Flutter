import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/header_logo.dart';
import 'package:otm_inventory/pages/authentication/login/view/widgets/otp_view.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/header_title_note_text_widget_.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/widgets/top_divider_widget.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/action_buttons_company_sign_up.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/company_email_textfield.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/company_name_textfield.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/phone_number_view_company_sign_up.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/preferred_image_size_view.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/upload_photo_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class CompanySignUpScreen extends StatefulWidget {
  const CompanySignUpScreen({super.key});

  @override
  State<CompanySignUpScreen> createState() => _CompanySignUpScreenState();
}

class _CompanySignUpScreenState extends State<CompanySignUpScreen> {
  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          // appBar: BaseAppBar(
          //     appBar: AppBar(),
          //     title: 'company_details'.tr,
          //     isCenterTitle: false,
          //     isBack: false,
          //     widgets: actionButtons()),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : Form(
                        key: controller.formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              TopDividerWidget(
                                flex1: 3,
                                flex2: 3,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 14, 16, 0),
                                child: HeaderLogo(),
                              ),
                              HeaderTitleNoteTextWidget(
                                title: 'whats_your_company_details'.tr,
                              ),
                              UploadPhotoView(),
                              PreferredImageSizeView(),
                              // SizedBox(
                              //   height: 26,
                              // ),
                              // Divider(
                              //     height: 1,
                              //     thickness: 1,
                              //     color: dividerColor),
                              CompanyNameTextField(),
                              CompanyEmailTextField(),
                              PhoneNumberViewCompanySignUp(),
                              ActionButtonsCompanySignUp()
                              // HeadOfficeLocationViewCompanySignup(),
                              // CurrencyTextFieldCompanySignUp()
                            ],
                          ),
                        ),
                      ));
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
