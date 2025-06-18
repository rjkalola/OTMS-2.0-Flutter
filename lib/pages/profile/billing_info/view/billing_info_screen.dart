import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/login/controller/login_controller.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/general_view.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/tax_info_view.dart';
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
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class BillingInfoScreen extends StatefulWidget {
  const BillingInfoScreen({super.key});

  @override
  State<BillingInfoScreen> createState() => _BillingInfoScreenState();
}

class _BillingInfoScreenState extends State<BillingInfoScreen> {
  final controller = Get.put(BillingInfoController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'billing_info'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor,
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? const Center(
                      child: Text("No Internet"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GeneralView(),
                        TaxInfoView()
                      ],
                    )),
            );
          }),
        ),
      ),
    );
  }
}
