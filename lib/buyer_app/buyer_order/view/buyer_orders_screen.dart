import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_header_view.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_list.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/delivery_to_text_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> {
  final controller = Get.put(BuyerOrderController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'orders'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchAddressController,
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
                      },
                    )
                  : controller.isMainViewVisible.value
                      ? GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          onPanDown: (_) => FocusScope.of(context).unfocus(),
                          child: KeyboardActions(
                            config: AppUtils.buildKeyboardConfig(
                                focusNodes: controller.qtyFocusNodes),
                            child: Column(
                              children: [
                                BuyerOrderHeaderView(),
                                DeliveryToTextWidget(text: "(Haringey OT)"),
                                BuyerOrderList()
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      // CardViewDashboardItem(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //   child: const Text(
      //     "Stats",
      //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      //   ),
      // ),
      SizedBox(
        width: 6,
      ),
      InkWell(
        onTap: () {
          if (controller.isSearchEnable.value) {
            controller.clearSearch();
          }
          controller.isSearchEnable.value = !controller.isSearchEnable.value;
        },
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: controller.isSearchEnable.value
              ? Icon(
                  Icons.close,
                  color: primaryTextColor_(context),
                )
              : ImageUtils.setSvgAssetsImage(
                  path: Drawable.searchIcon,
                  width: 24,
                  height: 24,
                  color: primaryTextColor_(context)),
        ),
      ),
      Visibility(
          visible: !UserUtils.isAdmin(), child: const SizedBox(width: 10)),
      Visibility(
        visible: UserUtils.isAdmin(),
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            if (UserUtils.isAdmin()) {
              // controller.showMenuItemsDialog(Get.context!);
            }
          },
        ),
      ),
    ];
  }
}
