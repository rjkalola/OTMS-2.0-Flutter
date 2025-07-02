import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/billing_details_screen.dart';
import 'package:otm_inventory/pages/profile/company_billings/controller/company_billings_controller.dart';
import 'package:otm_inventory/pages/profile/company_billings/view/widgets/company_card_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class CompanyBillingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> companies = [
    {
      'name': 'DCK Construction',
      'trade': 'Backend',
      'rate': '200.00',
      'status': 'Active'
    },
    {
      'name': 'Tagir Construction',
      'trade': 'Backend',
      'rate': '184.00',
      'status': 'Active'
    },
    {
      'name': 'DOM Construction',
      'trade': 'Backend',
      'rate': '184.00',
      'status': 'Inactive'
    },
  ];

  final controller = Get.put(CompanyBillingsController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? const Center(
              child: Text("No Internet"),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return CompanyCard(company: companies[index]);
                  },
                )
          ),
        ),
      )
    )
    )
    );
  }
}

