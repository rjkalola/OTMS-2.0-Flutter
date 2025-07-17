import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/select_shift/controller/select_shift_controller.dart';
import 'package:otm_inventory/pages/check_in/select_shift/view/widgets/search_shift.dart';
import 'package:otm_inventory/pages/check_in/select_shift/view/widgets/shifts_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/map_view/bottom_curve_container.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/map_view/map_back_arrow.dart';
import 'package:otm_inventory/widgets/other_widgets/selection_screen_header_view.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';

class SelectShiftScreen extends StatefulWidget {
  const SelectShiftScreen({super.key});

  @override
  State<SelectShiftScreen> createState() => _SelectShiftScreenState();
}

class _SelectShiftScreenState extends State<SelectShiftScreen> {
  final controller = Get.put(SelectShiftController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: controller.isMainViewVisible.value,
              child: Column(children: [
                Flexible(
                  flex: 2,
                  child: Stack(
                    children: [
                      CustomMapView(
                        onMapCreated: controller.onMapCreated,
                        target: controller.center,
                      ),
                      MapBackArrow(onBackPressed: () {
                        Get.back();
                      }),
                      BottomCurveContainer()
                    ],
                  ),
                ),
                Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        SelectionScreenHeaderView(
                          title: 'select_shift'.tr,
                          onBackPressed: () {
                            Get.back();
                          },
                        ),
                        SearchShift(),
                        ShiftsList(),
                        TextViewWithContainer(
                          onTap: (){
                            Get.back();
                          },
                          margin: EdgeInsetsDirectional.all(16),
                          padding:EdgeInsetsDirectional.all(9) ,
                          width: double.infinity,
                          text: 'cancel'.tr,
                          borderColor: Colors.grey,
                          alignment: Alignment.center,
                          borderRadius: 45,
                        )
                      ],
                    ))
              ]),
            ),
          ),
        ),
      )),
    );
  }
}
