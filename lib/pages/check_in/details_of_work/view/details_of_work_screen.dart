import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/check_in/details_of_work/controller/details_of_work_controller.dart';
import 'package:belcka/pages/check_in/details_of_work/view/widgets/before_photos_list.dart';
import 'package:belcka/pages/check_in/details_of_work/view/widgets/description_text_field.dart';
import 'package:belcka/pages/check_in/details_of_work/view/widgets/photos_before_text.dart';
import 'package:belcka/pages/check_in/details_of_work/view/widgets/save_button_details_of_work.dart';
import 'package:belcka/pages/check_in/details_of_work/view/widgets/type_of_work_textfield.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/utils/app_utils.dart';
class DetailsOfWorkScreen extends StatefulWidget {
  const DetailsOfWorkScreen({super.key});

  @override
  State<DetailsOfWorkScreen> createState() => _DetailsOfWorkScreenState();
}

class _DetailsOfWorkScreenState extends State<DetailsOfWorkScreen> {
  final controller = Get.put(DetailsOfWorkController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: backgroundColor_(context),
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
                     Divider(
                      thickness: 1,
                      height: 1,
                      color: dividerColor_(context),
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
