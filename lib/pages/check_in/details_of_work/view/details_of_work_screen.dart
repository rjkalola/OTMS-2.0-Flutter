import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/controller/details_of_work_controller.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/view/widgets/before_photos_list.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/view/widgets/description_text_field.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/view/widgets/photos_before_text.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/view/widgets/save_button_details_of_work.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/view/widgets/type_of_work_textfield.dart';
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

class DetailsOfWorkScreen extends StatefulWidget {
  const DetailsOfWorkScreen({super.key});

  @override
  State<DetailsOfWorkScreen> createState() => _DetailsOfWorkScreenState();
}

class _DetailsOfWorkScreenState extends State<DetailsOfWorkScreen> {
  final controller = Get.put(DetailsOfWorkController());

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
          title: 'details_of_work'.tr,
          isCenterTitle: false,
          isBack: true,
        ),
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
                    TypeOfWorkTextField(),
                    DescriptionTextField(),
                    PhotosBeforeText(),
                    BeforePhotosList(
                      onGridItemClick: controller.onGridItemClick,
                      filesList: controller.filesList,
                      photosType: controller.photosType,
                    ),
                    // storeListController.storeList.isNotEmpty
                    //     ? StoreListView()
                    //     : StoreListEmptyView(),
                    const SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
              SaveButtonDetailsOfWork()
            ]),
          ),
        ),
      )),
    );
  }
}
