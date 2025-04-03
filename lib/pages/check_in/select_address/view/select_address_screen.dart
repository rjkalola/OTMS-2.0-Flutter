import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/select_address/controller/select_address_controller.dart';
import 'package:otm_inventory/pages/check_in/select_address/view/widgets/address_list_widget.dart';
import 'package:otm_inventory/pages/check_in/select_address/view/widgets/footer_status_view.dart';
import 'package:otm_inventory/pages/check_in/select_address/view/widgets/search_address_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  final controller = Get.put(SelectAddressController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'select_address'.tr,
            isCenterTitle: false,
            isBack: true,
            widgets: actionButtons()),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Column(children: [
              Expanded(
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: dividerColor,
                    ),
                    const SearchAddressWidget(),
                    // storeListController.storeList.isNotEmpty
                    //     ? StoreListView()
                    //     : StoreListEmptyView(),
                    const SizedBox(
                      height: 6,
                    ),
                    AddressListWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              FooterStatusView()
            ]),
          ),
        ),
      )),
    );
  }

  List<Widget>? actionButtons() {
    return [
      IconButton(
        icon: SvgPicture.asset(
          width: 30,
          Drawable.filterIcon,
        ),
        onPressed: () {
          controller.showFilterByDialog();
        },
      ),
      IconButton(
        icon: SvgPicture.asset(
          width: 24,
          Drawable.sortIcon,
        ),
        onPressed: () {
          controller.showSortByDialog();
        },
      ),
    ];
  }
}
