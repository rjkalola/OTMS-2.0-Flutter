import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/select_shift/controller/select_shift_controller.dart';
import 'package:otm_inventory/pages/check_in/select_shift/view/widgets/search_shift.dart';
import 'package:otm_inventory/pages/check_in/select_shift/view/widgets/shifts_list.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/stop_shift_button.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/add_note_widget.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/start_stop_box_row.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/submit_for_approval_button.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/total_hours_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: dashBoardBgColor,
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
                  child: CustomMapView(
                      onMapCreated: controller.onMapCreated,
                      target: controller.center),
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
