import 'package:belcka/pages/timesheet/time_sheet_filter/view/widgets/all_items.dart';
import 'package:belcka/pages/timesheet/time_sheet_filter/view/widgets/categories_list.dart';
import 'package:belcka/pages/timesheet/time_sheet_filter/view/widgets/timesheet_filter_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../controller/time_sheet_filter_controller.dart';

class TimesheetFilterScreen extends StatefulWidget {
  const TimesheetFilterScreen({
    super.key,
  });

  @override
  State<TimesheetFilterScreen> createState() => _TimesheetFilterScreenState();
}

class _TimesheetFilterScreenState extends State<TimesheetFilterScreen> {
  final stockFilterController = Get.put(TimeSheetFilterController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor_(context),
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
                                flex: 3,
                                child: Container(
                                    color: Colors.grey,
                                    child: TimesheetFilterList())),
                            Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    AllItems(),
                                    CategoriesList()
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: PrimaryBorderButton(
                                  buttonText: 'apply'.tr,
                                  fontColor: defaultAccentColor_(context),
                                  borderColor: defaultAccentColor_(context),
                                  onPressed: () {
                                    stockFilterController.applyFilter();
                                    // Get.back();
                                  },
                                )),
                            const SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: PrimaryBorderButton(
                                buttonText: 'clear'.tr,
                                fontColor: Colors.red,
                                borderColor: Colors.red,
                                onPressed: () {
                                  stockFilterController.clearFilter();
                                  // Get.back();
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget dividerItem() =>  Divider(
        thickness: 0.5,
        height: 0.5,
        color: dividerColor_(context),
      );
}
