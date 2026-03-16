import 'package:belcka/buyer_app/categories/catalogue_list/controller/buyer_catalogue_controller.dart';
import 'package:belcka/buyer_app/categories/catalogue_list/view/buyer_catalogue_list.dart';
import 'package:belcka/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerCatalogueScreen extends StatelessWidget {
  final controller = Get.put(BuyerCatalogueController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'catalogue'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
                widgets: actionButtons(),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.buyerCatalogueListApi(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            BuyerCatalogueList()
                          ],
                        ),
                      ),
              ),
              bottomNavigationBar: CommonBottomNavigationBarWidget(),
            ),
          ))),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: true,
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            controller.moveToScreen(appRout: AppRoutes.buyerAddCatalogueScreen);
          },
        ),
      ),
    ];
  }
}
