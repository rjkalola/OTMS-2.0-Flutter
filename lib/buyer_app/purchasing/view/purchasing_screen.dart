import 'package:belcka/buyer_app/purchasing/controller/purchasing_controller.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/hire_card_view.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/inventory_card_view.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/orders_card_view.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/other_card_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PurchasingScreen extends StatefulWidget {
  const PurchasingScreen({super.key});

  @override
  State<PurchasingScreen> createState() => _PurchasingScreenState();
}

class _PurchasingScreenState extends State<PurchasingScreen> {
  final controller = Get.put(PurchasingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: "purchasing".tr,
                isCenterTitle: false,
                bgColor: backgroundColor_(context),
                widgets: actionButtons(),
                isBack: true,
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? Center(
                        child: Text("no_internet_text".tr),
                      )
                    : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: backgroundColor_(context),
                              boxShadow: [
                                AppUtils.boxShadow(shadowColor_(context), 6)
                              ],
                              border: Border.all(
                                  width: 0.6, color: Colors.transparent),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(45),
                                  bottomRight: Radius.circular(45)),
                            ),
                            child: Column(
                              children: [],
                            ),
                          ),
                          Visibility(
                            visible: controller.isMainViewVisible.value,
                            child: Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  OrdersCardView(),
                                  OtherCardView(),
                                  InventoryCardView(),
                                  // HireCardView()
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
              ),
              // This is where bottomNavigationBar should go
            ),
          ),
        ));
  }

  List<Widget>? actionButtons() {
    return [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {},
      ),
    ];
  }
}
