import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/view/widgets/add_note_widget.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/view/widgets/approve_reject_buttons.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/view/widgets/start_stop_box_row.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/view/widgets/total_hours_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/other_widgets/selection_screen_header_view.dart';

class WorkLogRequestScreen extends StatefulWidget {
  const WorkLogRequestScreen({super.key});

  @override
  State<WorkLogRequestScreen> createState() => _WorkLogRequestScreenState();
}

class _WorkLogRequestScreenState extends State<WorkLogRequestScreen> {
  final controller = Get.put(WorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SelectionScreenHeaderView(
                        title: 'my_shift'.tr,
                        statusText: StringHelper.capitalizeFirstLetter(
                            controller.workLogInfo.value.statusText ?? ""),
                        statusColor: controller.getStatusColor(
                            controller.workLogInfo.value.status ?? 0),
                        onBackPressed: () {
                          controller.onBackPress();
                        },
                      ),
                      StartStopBoxRow(),
                      TotalHoursRow(),
                      AddNoteWidget(
                          isReadOnly: true,
                          controller: controller.noteController),
                      ApproveRejectButtons(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
                        onClickApprove: () {},
                        onClickReject: () {},
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        )),
      ),
    );
  }
}
