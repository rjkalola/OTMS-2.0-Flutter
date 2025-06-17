import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/shifts/archive_shift_list/controller/archive_shift_list_controller.dart';
import 'package:otm_inventory/pages/shifts/archive_shift_list/view/widgets/search_archive_shift.dart';
import 'package:otm_inventory/pages/shifts/archive_shift_list/view/widgets/archive_shifts_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class ArchiveShiftListScreen extends StatefulWidget {
  const ArchiveShiftListScreen({super.key});

  @override
  State<ArchiveShiftListScreen> createState() => _ArchiveShiftListScreenState();
}

class _ArchiveShiftListScreenState extends State<ArchiveShiftListScreen> {
  final controller = Get.put(ArchiveShiftListController());

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
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'archived_shifts'.tr,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
              },
              bgColor: dashBoardBgColor,
            ),
            body: Obx(() {
              return ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            controller.getArchiveShiftListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Divider(),
                              SearchArchiveShift(),
                              ArchiveShiftsList()
                            ],
                          ),
                        ));
            }),
          ),
        ),
      ),
    );
  }
}
