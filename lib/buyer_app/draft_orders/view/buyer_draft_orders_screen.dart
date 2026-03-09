import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_delivered_order_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_proceed_order_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_products_list.dart';
import 'package:belcka/buyer_app/draft_orders/controller/buyer_draft_orders_controller.dart';
import 'package:belcka/buyer_app/draft_orders/view/buyer_draft_order_list.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerDraftOrdersScreen extends StatefulWidget {
  const BuyerDraftOrdersScreen({super.key});

  @override
  State<BuyerDraftOrdersScreen> createState() => _BuyerDraftOrdersScreenState();
}

class _BuyerDraftOrdersScreenState extends State<BuyerDraftOrdersScreen> {
  final controller = Get.put(BuyerDraftOrdersController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'draft_orders'.tr,
              isCenterTitle: false,
              isBack: true,
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
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          // controller.getCompanyDetailsApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: BuyerDraftOrderList(),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      const SizedBox(width: 6),
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
                  color: primaryTextColor_(context),
                )
              : ImageUtils.setSvgAssetsImage(
                  path: Drawable.searchIcon,
                  width: 24,
                  height: 24,
                  color: primaryTextColor_(context),
                )),
        ),
      ),
      SizedBox(
        width: 10,
      ),
    ];
  }
}
