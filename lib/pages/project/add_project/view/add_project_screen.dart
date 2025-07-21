import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/project/add_project/controller/add_project_controller.dart';
import 'package:otm_inventory/pages/project/add_project/view/widgets/budget_textfield.dart';
import 'package:otm_inventory/pages/project/add_project/view/widgets/description_textfield.dart';
import 'package:otm_inventory/pages/project/add_project/view/widgets/project_name_textfield.dart';
import 'package:otm_inventory/pages/project/add_project/view/widgets/site_address_textfield.dart';
import 'package:otm_inventory/pages/project/add_project/view/widgets/status_textfield.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/textfield/reusable/drop_down_text_field.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => AddProjectScreenState();
}

class AddProjectScreenState extends State<AddProjectScreen> {
  final controller = Get.put(AddProjectController());

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
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          // controller.isInternetNotAvailable.value = false;
                          // controller.getTeamListApi();
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
                                  child: SingleChildScrollView(child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ProjectNameTextField(),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      DropDownTextField(
                                        title: 'select_shift'.tr,
                                        controller: controller.shiftController,
                                        onValueChange: (value) {},
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      DropDownTextField(
                                        title: 'select_teams'.tr,
                                        controller: controller.teamController,
                                        onValueChange: (value) {},
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      SiteAddressTextField(),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      BudgetTextField(),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      DropDownTextField(
                                        title: 'add_geofence'.tr,
                                        controller:
                                        controller.addGeofenceController,
                                        onValueChange: (value) {},
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      DropDownTextField(
                                        title: 'add_addresses'.tr,
                                        controller:
                                        controller.addAddressesController,
                                        onValueChange: (value) {},
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      StatusTextField(),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      DescriptionTextField(),
                                      SizedBox(
                                        height: 18,
                                      ),
                                    ],
                                  ),),
                                ),
                              ),
                            ),
                            PrimaryButton(
                                padding: EdgeInsets.fromLTRB(14, 18, 14, 16),
                                buttonText: 'save'.tr,
                                color: controller.isSaveEnable.value
                                    ? defaultAccentColor_(context)
                                    : defaultAccentLightColor_(context),
                                onPressed: () {
                                  if (controller.isSaveEnable.value) {}
                                })
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
