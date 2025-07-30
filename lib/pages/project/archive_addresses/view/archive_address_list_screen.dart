import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/project/archive_addresses/controller/archive_address_list_controller.dart';
import 'package:otm_inventory/pages/project/archive_addresses/view/widgets/address_list.dart';
import 'package:otm_inventory/pages/project/archive_addresses/view/widgets/search_project.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class ArchiveAddressListScreen extends StatefulWidget {
  const ArchiveAddressListScreen({super.key});

  @override
  State<ArchiveAddressListScreen> createState() => _ArchiveAddressListScreenState();
}

class _ArchiveAddressListScreenState extends State<ArchiveAddressListScreen> {
  final controller = Get.put(ArchiveAddressListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor_(context),
        statusBarIconBrightness: Brightness.dark));
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
              title: 'archived_address'.tr,
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
                      controller.getArchiveAddressListApi();
                    },
                  )
                      : Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Column(
                      children: [
                        Divider(),
                        SearchProjectWidget(),
                        AddressList()
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
