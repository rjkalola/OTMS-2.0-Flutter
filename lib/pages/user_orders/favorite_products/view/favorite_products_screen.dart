import 'package:belcka/pages/user_orders/basket/view/widgets/basket_header_view.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/basket_items_list.dart';
import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/favorite_products/controller/favorite_products_controller.dart';
import 'package:belcka/pages/user_orders/favorite_products/view/widgets/favorite_products_list_widget.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/widgets/empty_cart_view.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  final controller = Get.put(FavoriteProductsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          child: Obx(
                () => GestureDetector(
              onTap: (){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                backgroundColor: dashBoardBgColor_(context),
                appBar: OrdersBaseAppBar(
                  appBar: AppBar(),
                  title: 'products'.tr,
                  isCenterTitle: false,
                  isBack: true,
                  bgColor: backgroundColor_(context),
                  autoFocus: true,
                  isClearVisible: false.obs,
                  onBackPressed: (){
                    controller.onBackPress();
                  },
                ),
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
                      ? (controller.bookmarkList.isNotEmpty) ? Column(
                    children: [

                      //Product list
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FavoriteProductsListWidget(),
                      )
                    ],
                  ) : EmptyStateView(
                    title: 'no_products_msg'.tr,
                    message:"",
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
