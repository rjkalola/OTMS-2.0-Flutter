import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/view/widgets/dashboard_stock_count_item.dart';
import 'package:otm_inventory/pages/dashboard/view/widgets/purchase_order_count_item.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/app_storage.dart';
import '../../../../../widgets/CustomProgressbar.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dashboardController = Get.put(DashboardController());
  late var userInfo = UserInfo();

  @override
  void initState() {
    // showProgress();
    // setHeaderActionButtons();
    userInfo = Get.find<AppStorage>().getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(child: Obx(() {
      return ModalProgressHUD(
        inAsyncCall: dashboardController.isLoading.value,
        opacity: 0,
        progressIndicator: const CustomProgressbar(),
        child: Obx(() => Scaffold(
              backgroundColor: Colors.white,
              // backgroundColor: const Color(0xfff4f5f7),
              body: Visibility(
                visible: dashboardController.isMainViewVisible.value,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: dividerColor,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // PrimaryBorderButton(
                                //     buttonText: "Test Speed",
                                //     onPressed: () {
                                //       dashboardController.checkInternetSpeed();
                                //     },
                                //     textColor: defaultAccentColor,
                                //     borderColor: defaultAccentColor),
                                // TextFieldSelectStoreHomeTab(),
                                // HomeTabActionButtonsList(),
                                // HomeTabActionButtonsDotsList(),
                                // HomeTabHeaderButtonsList()
                                !StringHelper.isEmptyString(dashboardController
                                        .storeNameController.value.text)
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 6, 16, 12),
                                        child: PrimaryTextView(
                                          text: dashboardController
                                              .storeNameController.value.text,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: primaryTextColor,
                                        ),
                                      )
                                    : Container(),
                                DashboardStockCountItem(
                                  title: 'all'.tr,
                                  value: "${dashboardController.mAllStockCount} (${dashboardController.allTotalAmount.value})",
                                  // value:
                                  //     (dashboardController.mInStockCount.value +
                                  //             dashboardController
                                  //                 .mLowStockCount.value)
                                  //         .toString(),
                                  valueColor: Colors.green,
                                  onPressed: () {
                                    dashboardController.onClickAllStockItem();
                                  },
                                ),
                                DashboardStockCountItem(
                                  title: 'in_stock'.tr,
                                  value: "${dashboardController.mInStockCount} (${dashboardController.inStockAmount.value})",
                                  // value:
                                  //     (dashboardController.mInStockCount.value +
                                  //             dashboardController
                                  //                 .mLowStockCount.value)
                                  //         .toString(),
                                  valueColor: Colors.green,
                                  onPressed: () {
                                    // dashboardController.onClickInStockItem();
                                    dashboardController.onClickStockItem(
                                        AppConstants.stockCountType.inStock);
                                  },
                                ),

                                DashboardStockCountItem(
                                  title: 'low_stock'.tr,
                                  value: "${dashboardController.mLowStockCount} (${dashboardController.lowStockAmount.value})",
                                  valueColor: Colors.orange,
                                  onPressed: () {
                                    dashboardController.onClickStockItem(
                                        AppConstants.stockCountType.lowStock);
                                  },
                                ),

                                DashboardStockCountItem(
                                  title: 'out_of_stock'.tr,
                                  value: "${dashboardController.mOutOfStockCount} (${dashboardController.outOfStockAmount.value})",
                                  valueColor: Colors.red,
                                  onPressed: () {
                                    dashboardController.onClickStockItem(
                                        AppConstants.stockCountType.outOfStock);
                                  },
                                ),

                                Visibility(
                                  visible:
                                      dashboardController.mMinusStockCount > 0,
                                  child: DashboardStockCountItem(
                                    title: 'minus_stock'.tr,
                                    value: "${dashboardController.mMinusStockCount} (${dashboardController.minusStockAmount.value})",
                                    valueColor: Colors.red,
                                    onPressed: () {
                                      dashboardController.onClickStockItem(
                                          AppConstants
                                              .stockCountType.minusStock);
                                    },
                                  ),
                                ),
                                DashboardStockCountItem(
                                  title: 'finishing_products'.tr,
                                  value: "${dashboardController.mFinishingProductsCount} (${dashboardController.finishingAmount.value})",
                                  valueColor: darkYellowColor,
                                  onPressed: () {
                                    dashboardController.onClickStockItem(
                                        AppConstants
                                            .stockCountType.finishingStock);
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CardView(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 15, 16, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryTextView(
                                          text: 'purchase_order'.tr,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: primaryTextColor,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            PurchaseOrderCountItem(
                                              title: 'issued'.tr,
                                              count: dashboardController
                                                  .mIssuedCount.value,
                                              color: const Color(0xffe0eaf9),
                                              iconPath:
                                                  Drawable.dashboardIssuedIcon,
                                              iconColor:
                                                  const Color(0xff0052cc),
                                            ),
                                            PurchaseOrderCountItem(
                                              title: 'partially_received'.tr,
                                              count: dashboardController
                                                  .mPartiallyReceivedCount
                                                  .value,
                                              color: const Color(0xffe0f9fc),
                                              iconPath: Drawable
                                                  .dashboardPartiallyReceivedIcon,
                                              iconColor:
                                                  const Color(0xff09d0e8),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            PurchaseOrderCountItem(
                                              title: 'received'.tr,
                                              count: dashboardController
                                                  .mReceivedCount.value,
                                              color: const Color(0xffe5f8ed),
                                              iconPath: Drawable
                                                  .dashboardReceivedIcon,
                                              iconColor:
                                                  const Color(0xff3ecc7d),
                                            ),
                                            PurchaseOrderCountItem(
                                              title: 'cancelled'.tr,
                                              count: dashboardController
                                                  .mCancelledCount.value,
                                              color: const Color(0xfffceaea),
                                              iconPath: Drawable
                                                  .dashboardCancelledIcon,
                                              iconColor:
                                                  const Color(0xffea5455),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      //   child: SizedBox(
                      //     width: double.infinity,
                      //     child: PrimaryBorderButton(
                      //       buttonText: 'sync'.tr,
                      //       textColor: defaultAccentColor,
                      //       borderColor: defaultAccentColor,
                      //       onPressed: () {
                      //         dashboardController.onClickDownloadStockButton();
                      //       },
                      //     ),
                      //   ),
                      // )
                    ]),
              ),
            )),
      );
    }));
  }

// @override
// void dispose() {
//   homeTabController.dispose();
//   super.dispose();
// }
}
