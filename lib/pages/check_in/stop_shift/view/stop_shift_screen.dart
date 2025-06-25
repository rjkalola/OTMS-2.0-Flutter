import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/add_note_widget.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/start_stop_box_row.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/stop_shift_button.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/submit_for_approval_button.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/total_hours_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/other_widgets/selection_screen_header_view.dart';

class StopShiftScreen extends StatefulWidget {
  const StopShiftScreen({super.key});

  @override
  State<StopShiftScreen> createState() => _StopShiftScreenState();
}

class _StopShiftScreenState extends State<StopShiftScreen> {
  final controller = Get.put(StopShiftController());

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
        /* appBar: BaseAppBar(
          appBar: AppBar(),
          title:
              controller.isWorking.value ? 'my_shift'.tr : 'edit_my_shift'.tr,
          isCenterTitle: false,
          bgColor: dashBoardBgColor,
          isBack: true,
        ),*/
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Column(children: [
              Expanded(
                child: CustomMapView(
                    onMapCreated: controller.onMapCreated,
                    target: controller.center),
              ),
              Column(
                children: [
                  SelectionScreenHeaderView(
                    title: controller.isWorking.value
                        ? 'my_shift'.tr
                        : 'edit_my_shift'.tr,
                    onBackPressed: () {
                      Get.back();
                    },
                  ),
                  StartStopBoxRow(),
                  TotalHoursRow(),
                  Visibility(
                      visible: controller.isEdited.value,
                      child:
                          AddNoteWidget(controller: controller.noteController)),
                  controller.isWorking.value
                      ? StopShiftButton()
                      : Visibility(
                          visible: controller.isEdited.value,
                          child: SubmitForApprovalButton(),
                        )
                ],
              )
            ]),
          ),
        ),
      )),
    );
  }
}
