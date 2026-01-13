import 'package:belcka/pages/add_category/controller/add_category_controller.dart';
import 'package:belcka/pages/add_category/view/widgets/category_name_text_field.dart';
import 'package:belcka/pages/add_trades/view/widgets/category_select_view.dart';
import 'package:belcka/pages/add_trades/view/widgets/trade_name_text_field.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final controller = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    final enabled = controller.isSaveEnabled.value;
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "add_category".tr,
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
                ? Center(
              child: Text("no_internet_text".tr),
            )
                : SingleChildScrollView(
                child: CardViewDashboardItem(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryNameTextField(controller: controller.categoryController,
                      isEnabled: true,),

                      // Category field
                      SizedBox(height: 32),
                      Obx(() {
                        if (!controller.isShowSaveButton.value) {
                          return SizedBox.shrink();
                        }
                        final enabled = controller.isSaveEnabled.value;
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Opacity(
                            opacity: enabled ? 1.0 : 0.4,
                            child: ElevatedButton(
                              onPressed: enabled
                                  ? () {
                                FocusScope.of(context).unfocus();
                                controller.onSubmit();
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                defaultAccentColor_(context),
                                minimumSize:
                                const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'save'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                )),
          ),
          // This is where bottomNavigationBar should go

        ),
      ),
    )
    );
  }
}
