import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/edit_stock/controller/edit_stock_controller.dart';
import 'package:belcka/storeman_app/edit_stock/view/widgets/edit_stock_details.dart';
import 'package:belcka/storeman_app/edit_stock/view/widgets/edit_stock_footer.dart';
import 'package:belcka/storeman_app/edit_stock/view/widgets/edit_stock_header.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditStockScreen extends StatelessWidget {
  EditStockScreen({super.key});

  final controller = Get.put(EditStockController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'edit_stock'.tr,
              isCenterTitle: false,
              bgColor: Colors.white,
              isBack: true,
              shape: AppUtils.getAppbarShape(bottomLeft: 20, bottomRight: 20),
            ),
            backgroundColor: Colors.white,
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Visibility(
                visible: controller.isMainViewVisible.value,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GetBuilder<EditStockController>(
                              builder: (ctrl) => EditStockHeader(
                                product: ctrl.product,
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: dividerColor_(context),
                            ),
                            EditStockDetails(product: controller.product),
                          ],
                        ),
                      ),
                    ),
                    EditStockFooter(controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
