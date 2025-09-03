import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/shifts/archive_shift_list/controller/archive_shift_list_controller.dart';
import 'package:belcka/pages/shifts/archive_shift_list/view/widgets/search_archive_shift.dart';
import 'package:belcka/pages/shifts/archive_shift_list/view/widgets/archive_shifts_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class ArchiveShiftListScreen extends StatefulWidget {
  const ArchiveShiftListScreen({super.key});

  @override
  State<ArchiveShiftListScreen> createState() => _ArchiveShiftListScreenState();
}

class _ArchiveShiftListScreenState extends State<ArchiveShiftListScreen> {
  final controller = Get.put(ArchiveShiftListController());

  @override
  Widget build(BuildContext context) {
      AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'archived_shifts'.tr,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
              },
              bgColor: dashBoardBgColor_(context),
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
