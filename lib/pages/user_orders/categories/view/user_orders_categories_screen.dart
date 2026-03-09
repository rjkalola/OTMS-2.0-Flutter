import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_controller.dart';
import 'package:belcka/pages/user_orders/categories/view/widgets/user_orders_categories_list.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserOrdersCategoriesScreen extends StatefulWidget {
  const UserOrdersCategoriesScreen({super.key});

  @override
  State<UserOrdersCategoriesScreen> createState() => _UserOrdersCategoriesScreenState();
}

class _UserOrdersCategoriesScreenState extends State<UserOrdersCategoriesScreen> {

  final controller = Get.put(UserOrdersCategoriesController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
                  appBar: OrdersBaseAppBar(
                    appBar: AppBar(),
                    title: ''.tr,
                    isCenterTitle: false,
                    isBack: false,
                    bgColor: backgroundColor_(context),
                    widgets: actionButtons(),
                    isSearching: controller.isSearchEnable.value,
                    searchController: controller.searchController,
                    onValueChange: (value) {
                      controller.searchItem(value);
                    },
                    autoFocus: true,
                    isClearVisible: false.obs,
                  ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                onPressed: () {
                  controller.isInternetNotAvailable.value = false;
                },
              )
                  : controller.isMainViewVisible.value
                  ? Padding(
                    padding: EdgeInsets.all(12.0),
                    child:UserOrdersCategoriesList(),
                  )
                  : SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        onTap: () {
          controller.isSearchEnable.toggle();
          if (!controller.isSearchEnable.value) {
            controller.clearSearch();
          }
        },
        customBorder: const CircleBorder(),
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
      SizedBox(
        width: 4,
      ),
      InkWell(
        onTap: (){
          // open cart page
          controller.moveToScreen(AppRoutes.basketScreen,null);
        },
        child: Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined, size: 25),
              onPressed: () {
                controller.moveToScreen(AppRoutes.basketScreen,null);
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
      // IconButton(icon: Icon(Icons.filter_alt_outlined), onPressed: () {}),
      // IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: () {}),
    ];
  }
}
