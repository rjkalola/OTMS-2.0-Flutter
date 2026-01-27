import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/right_side_icons_list_widget.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/storeman_products_list_widget.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/storeman_searchbar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoremanCatalogScreen extends StatefulWidget {
  const StoremanCatalogScreen({super.key});

  @override
  State<StoremanCatalogScreen> createState() => _StoremanCatalogScreenState();
}
class _StoremanCatalogScreenState extends State<StoremanCatalogScreen> {
  final controller = Get.put(StoremanCatalogController());

  @override

  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                onPressed: () {
                  controller.isInternetNotAvailable.value = false;
                },
              )
                  : controller.isMainViewVisible.value
                  ? Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    //Top Search Bar
                    StoremanSearchbarWidget(),
                    // Catalog List + Side Icons
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product list
                          StoremanProductsListWidget(),
                          // Right-side icon bar
                          RightSideIconsListWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}