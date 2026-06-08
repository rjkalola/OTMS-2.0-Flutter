import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/storeman_app/stock_products_list/controller/stock_products_list_controller.dart';
import 'package:belcka/storeman_app/stock_products_list/view/widgets/stock_products_list_item.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StockProductsListScreen extends StatefulWidget {
  StockProductsListScreen({super.key});

  @override
  State<StockProductsListScreen> createState() =>
      _StockProductsListScreenState();
}
 
class _StockProductsListScreenState extends State<StockProductsListScreen> {
  late final StockProductsListController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<StockProductsListController>()) {
      Get.delete<StockProductsListController>(force: true);
    }
    controller = Get.put(StockProductsListController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.appBarTitle,
              isCenterTitle: false,
              bgColor: Colors.white,
              isBack: true,
              shape: AppUtils.getAppbarShape(bottomLeft: 20, bottomRight: 20),
              widgets: _actionButtons(context),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: controller.searchItem,
              onPressedClear: controller.clearSearch,
              autoFocus: true,
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.fetchProducts(isRefresh: true);
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor_(context),
                        ),
                        Expanded(
                          child: Visibility(
                            visible: controller.isMainViewVisible.value,
                            child: controller.productsList.isEmpty
                                ? EmptyStateView(
                                    title: 'no_products_msg'.tr,
                                    message: 'no_products_sub_msg'.tr,
                                  )
                                : ListView.separated(
                                    controller: controller.scrollController,
                                    padding:
                                        const EdgeInsets.only(bottom: 16),
                                    itemCount: controller.productsList.length +
                                        (controller.isLoadingMore.value
                                            ? 1
                                            : 0),
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1,
                                      thickness: 1,
                                      indent: StockProductsListItem
                                          .dividerIndent,
                                      color: dividerColor_(context),
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index >=
                                          controller.productsList.length) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Center(
                                            child: CustomProgressbar(),
                                          ),
                                        );
                                      }
                                      return StockProductsListItem(
                                        item: controller.productsList[index],
                                        onTap: () =>
                                            controller.onProductItemClick(
                                          controller.productsList[index],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? _actionButtons(BuildContext context) {
    return [
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          onTap: () {
            controller.isSearchEnable.value = true;
          },
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ImageUtils.setSvgAssetsImage(
              path: Drawable.searchIcon,
              width: 24,
              height: 24,
              color: primaryTextColor_(context),
            ),
          ),
        ),
      ),
      const SizedBox(width: 6),
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          onTap: controller.showFilterBottomSheet,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor_(context),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
    ];
  }
}
