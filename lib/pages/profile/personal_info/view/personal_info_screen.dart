import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/controller/login_controller.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_bank_account_number_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_bank_name_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_bank_sortcode_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_dob_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_email_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_first_last_name_textfield_widget.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_middle_name_textfield_widget.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_my_address_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_name_on_bank_account_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_phone_extension_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_phone_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_postcode_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_screen_section_card.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_tax_name_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_tax_nin_textfield.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/widgets/personal_info_tax_utr_textfield.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final loginController = Get.put(LoginController());

  //final TextEditingController firstNameFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('personal_info'.tr),
            centerTitle: false,
          ),
          backgroundColor: backgroundColor,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                  buttonText: 'save'.tr,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    //save api
                  }),
            ),
          ),
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: loginController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: loginController.isInternetNotAvailable.value
                  ? const Center(
                      child: Text("No Internet"),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(11.25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PersonalInfoSectionCard(
                            backgroundColor: Colors.white,
                            title: 'general'.tr,
                            children: [
                              PersonalInfoFirstLastNameTextfieldWidget(),
                              PersonalInfoMiddleNameTextfieldWidget(),
                              PersonalInfoEmailTextfieldWidget(),
                              PersonalInfoDOBTextfieldWidget(),
                              Row(
                                children: [
                                  Expanded(
                                      child:
                                          PersonalInfoPostcodeTextfieldWidget()),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: Text('search'.tr)),
                                ],
                              ),
                              PersonalInfoMyAddressTextfieldWidget(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child:
                                        PersonalInfoPhoneExtensionFieldWidget(),
                                  ),
                                  Flexible(
                                      flex: 3,
                                      child:
                                          PersonalInfoPhoneTextfieldWidget()),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PersonalInfoSectionCard(
                            backgroundColor: Colors.white,
                            title: 'tax_info'.tr,
                            children: [
                              PersonalInfoTaxNameTextfieldWidget(),
                              PersonalInfoTaxUTRTextfieldWidget(),
                              PersonalInfoTaxNINTextfieldWidget(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PersonalInfoSectionCard(
                            backgroundColor: Colors.white,
                            title: 'Bank Details',
                            children: [
                              PersonalInfoNameOnBankAccountTextfieldWidget(),
                              PersonalInfoBankNameTextFieldWidget(),
                              PersonalInfoBankAccountNumberTextFieldWidget(),
                              PersonalInfoBankSortcodeTextFieldWidget(),
                            ],
                          ),
                        ],
                      )),
            );
          }),
        ),
      ),
    );
  }
}
