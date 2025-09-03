import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/project/add_address/controller/add_address_controller.dart';
import 'package:belcka/pages/project/add_address/view/widgets/site_address_textfield.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => AddAddressScreenState();
}

class AddAddressScreenState extends State<AddAddressScreen> {
  final controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.title.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
              // widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                              child: Form(
                                key: controller.formKey,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 18,
                                        ),
                                        SiteAddressTextField(),
                                        SizedBox(
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                                padding: EdgeInsets.fromLTRB(14, 16, 14, 16),
                                buttonText: 'save'.tr,
                                color: controller.isSaveEnable.value
                                    ? defaultAccentColor_(context)
                                    : defaultAccentLightColor_(context),
                                onPressed: () {
                                  if (controller.isSaveEnable.value){
                                    if (controller.addressDetailsInfo != null) {
                                      controller.updateAddressApi();
                                    }
                                    else{
                                      controller.addAddressApi();
                                    }
                                  }
                                })
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.projectInfo != null,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            //controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }
}
