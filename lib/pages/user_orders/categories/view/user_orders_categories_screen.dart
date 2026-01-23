import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_controller.dart';
import 'package:belcka/pages/user_orders/categories/view/widgets/user_orders_categories_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserOrdersCategoriesScreen extends StatelessWidget {
  UserOrdersCategoriesScreen({super.key});

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
            appBar: AppBar(
              backgroundColor:backgroundColor_(context),
              elevation: 0,
              actions: actionButtons(),
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
      IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: () {}),
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
      IconButton(icon: Icon(Icons.filter_alt_outlined), onPressed: () {}),
      IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: () {}),
    ];
  }
}
