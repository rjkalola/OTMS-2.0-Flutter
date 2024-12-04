import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_filter/view/widgets/all_items.dart';
import 'package:otm_inventory/pages/stock_filter/view/widgets/stock_filter_categories_list.dart';
import 'package:otm_inventory/pages/stock_filter/view/widgets/stock_filter_supplier_list.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../../widgets/appbar/base_appbar.dart';
import '../controller/stock_filter_controller.dart';

class StockFilterScreen extends StatefulWidget {
  const StockFilterScreen({
    super.key,
  });

  @override
  State<StockFilterScreen> createState() => _StockFilterScreenState();
}

class _StockFilterScreenState extends State<StockFilterScreen> {
  final stockFilterController = Get.put(StockFilterController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'stock_filter'.tr,
              isCenterTitle: false,
              isBack: true,
            ),
            body: ModalProgressHUD(
              inAsyncCall: stockFilterController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Visibility(
                visible: stockFilterController.isMainViewVisible.value,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dividerItem(),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                  color: Colors.grey,
                                  child: StockFilterSupplierList())),
                          Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  AllItems(),
                                  StockFilterCategoriesList()
                                ],
                              ))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Row(
                    //     children: [
                    //       Flexible(
                    //           fit: FlexFit.tight,
                    //           flex: 1,
                    //           child:PrimaryBorderButton(
                    //             buttonText: 'apply'.tr,
                    //             textColor: defaultAccentColor,
                    //             borderColor: defaultAccentColor,
                    //             onPressed: () {
                    //               stockFilterController.applyFilter();
                    //               // Get.back();
                    //             },
                    //           )
                    //       ),
                    //       const SizedBox(
                    //         width: 12,
                    //       ),
                    //       Flexible(
                    //         fit: FlexFit.tight,
                    //         flex: 1,
                    //         child: PrimaryBorderButton(
                    //           buttonText: 'cancel'.tr,
                    //           textColor: Colors.red,
                    //           borderColor: Colors.red,
                    //           onPressed: () {
                    //             Get.back();
                    //           },
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget dividerItem() => const Divider(
        thickness: 0.5,
        height: 0.5,
        color: dividerColor,
      );
}
