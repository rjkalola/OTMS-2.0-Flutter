import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/company_billings/controller/company_billings_controller.dart';
import 'package:otm_inventory/pages/profile/company_billings/view/widgets/company_card_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class CompanyBillingsScreen extends StatelessWidget {

  final controller = Get.put(CompanyBillingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'billing_info'.tr,
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
                ? const Center(
              child: Text("No Internet"),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: controller.companyList.length,
                  itemBuilder: (context, position) {
                    return CompanyCardWidget(company: controller.companyList[position]);
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

