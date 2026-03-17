import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/category_expand_grid.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/right_side_icons_list_widget.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/storeman_catalog_header_view.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/storeman_products_list_widget.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/toolbar_menu_item_text_view.dart';
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
    return Obx(() => Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: OrdersBaseAppBar(
              appBar: AppBar(),
              title: '',
              isCenterTitle: false,
              isBack: false,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              onBackPressed: () {
                controller.onBackPress();
              },
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: (value) {
                controller.searchItem(value);
              },
              autoFocus: true,
              isClearVisible: false.obs,
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
                },
              )
                  : controller.isMainViewVisible.value
                  ? Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        StoremanCatalogHeaderView(),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: controller
                                    .products.isNotEmpty
                                    ? StoremanProductsListWidget()
                                    : EmptyStateView(
                                  title: 'no_products_msg'.tr,
                                  message:
                                  "${'no_products_sub_msg'.tr}.",
                                ),
                              ),
                              RightSideIconsListWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Obx(() => AnimatedPositioned(
                      duration:
                      const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      right: controller.isCategoryExpanded.value
                          ? 0
                          : -MediaQuery.of(context).size.width,
                      top: 20,
                      bottom: 0,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        color: dashBoardBgColor_(context),
                        child: CategoryExpandGrid(),
                      ),
                    )),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    ),);
  }

  List<Widget>? actionButtons() {
    return [

      Visibility(
        visible: controller.isResetEnable.value,
        child: ToolbarMenuItemTextView(
          text: 'reset'.tr,
          padding: EdgeInsets.only(left: 6, right: 14),
          onTap: () {
            controller.clearFilter();
          },
        ),
      ),

      Visibility(
        visible: !controller.isCategoryExpanded.value,
        child: GestureDetector(
          onTap: () {
            controller.isSearchEnable.toggle();
            if (!controller.isSearchEnable.value) {
              controller.clearSearch();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Obx(() => controller.isSearchEnable.value
                ? Icon(
              Icons.close,
            )
                : ImageUtils.setSvgAssetsImage(
              path: Drawable.searchIcon,
              width: 24,
              height: 24,
            )),
          ),
        ),
      ),

      SizedBox(
        width: 2,
      ),
      // IconButton(icon: Icon(Icons.bookmark), onPressed: () {}),
      GestureDetector(
        onTap: () {
          // open cart page
          FocusManager.instance.primaryFocus?.unfocus();
          controller.moveToScreen(AppRoutes.basketScreen, null);
        },
        child: Stack(
          children: [
            IconButton(
              icon: CartIconWidget(),
              color: backgroundColor_(context),
              onPressed: () {
                controller.moveToScreen(AppRoutes.basketScreen, null);
              },
            ),
            if (controller.cartCount.value > 0)
              Positioned(
                right: 6,
                top: 3,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    controller.cartCount.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      SizedBox(
        width: 10,
      ),
    ];
  }
}
