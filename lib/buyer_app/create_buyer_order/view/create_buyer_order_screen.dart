import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_header_view.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/delivery_to_text_widget.dart';
import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_controller.dart';
import 'package:belcka/buyer_app/create_buyer_order/view/widgets/buyer_create_order_header_view.dart';
import 'package:belcka/buyer_app/create_buyer_order/view/widgets/buyer_create_order_item_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBuyerOrderScreen extends StatefulWidget {
  CreateBuyerOrderScreen({super.key});

  @override
  State<CreateBuyerOrderScreen> createState() => _CreateBuyerOrderScreenState();
}

class _CreateBuyerOrderScreenState extends State<CreateBuyerOrderScreen> {
  final controller = Get.put(CreateBuyerOrderController());

  @override
  void initState() {
    super.initState();
  }

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
              title: 'create_order'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: [],
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: (value) {
                controller.searchItem(value);
              },
              autoFocus: true,
              isClearVisible: false.obs,
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CustomProgressbar());
              }

              if (controller.isInternetNotAvailable.value) {
                return NoInternetWidget(
                  onPressed: () {
                    controller.isInternetNotAvailable.value = false;
                  },
                );
              }

              if (!controller.isMainViewVisible.value) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  BuyerCreateOrderHeaderView(),
                  Expanded(
                    child: BuyerCreateOrderItemList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: PrimaryButton(
                              buttonText: 'draft'.tr,
                              onPressed: () {},
                              color: Colors.redAccent,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: PrimaryButton(
                              buttonText: 'create_order'.tr,
                              onPressed: () {},
                              color: Colors.green,
                            ))
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
