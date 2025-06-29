import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/bank_details_view.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/general_view.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/tax_info_view.dart';
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
            widgets: actionButtons(),
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
                      child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GeneralView(),
                              TaxInfoView(),
                              BankDetailsView(),
                            ],
                          ))),
            );
          }),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ElevatedButton(
          onPressed: () {
            controller.onSubmit();
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(126, 42),
            backgroundColor: blueBGButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Text('save'.tr, style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
        ),
      )
    ];
  }
}
