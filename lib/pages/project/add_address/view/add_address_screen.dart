import 'package:belcka/pages/project/add_address/view/widgets/address_circle_size_progress.dart';
import 'package:belcka/pages/project/add_address/view/widgets/place_list.dart';
import 'package:belcka/pages/project/add_address/view/widgets/search_address_text_field.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/slider/custom_slider.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
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

  void searchAddress() {
    FocusScope.of(context).unfocus();
    final txt = controller.searchAddressController.value.text.trim();
    if (txt.isNotEmpty) {
      controller.lookupAddress(txt);
    }
  }

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
                              child: Stack(
                                children: [
                                  Form(
                                    key: controller.formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 16,
                                        ),
                                        SearchAddressTextField(),
                                        SizedBox(height: 16),
                                        Padding(
                                          padding:EdgeInsets.symmetric(horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                onPressed: (){
                                                  searchAddress();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(100, 40),
                                                  backgroundColor: defaultAccentColor_(context),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                ),
                                                child: Text(
                                                  'search'.tr,
                                                  style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 22,
                                        ),
                                        Visibility(
                                          visible: !StringHelper.isEmptyString(
                                              controller.siteAddressController
                                                  .value.text),
                                          child: Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SiteAddressTextField(),
                                                SizedBox(
                                                  height: 22,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16, bottom: 4),
                                                  child: TitleTextView(
                                                    text:
                                                        "${'area_size'.tr} (${controller.circleRadius.value.toInt()} Meter)",
                                                  ),
                                                ),
                                                AddressCircleSizeProgress(),
                                                SizedBox(
                                                  height: 18,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16,
                                                            right: 16),
                                                    child: Stack(
                                                      children: [
                                                        CustomMapView(
                                                          onMapCreated:
                                                              controller
                                                                  .onMapCreated,
                                                          onCameraMove:
                                                              (position) {},
                                                          circles: controller
                                                              .circles,
                                                          markers:
                                                              controller.marker,
                                                          target: controller
                                                              .selectedLatLng,
                                                          initialZoom: 17,
                                                        ),
                                                        // Align(
                                                        //   alignment: Alignment.center,
                                                        //   child: Icon(
                                                        //     Icons.location_on,
                                                        //     size: 45,
                                                        //     color: defaultAccentColor_(
                                                        //         context),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  PlaceList()
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !StringHelper.isEmptyString(
                                  controller.siteAddressController.value.text),
                              child: PrimaryButton(
                                  padding: EdgeInsets.fromLTRB(14, 16, 14, 16),
                                  buttonText: 'save'.tr,
                                  color: controller.isSaveEnable.value
                                      ? defaultAccentColor_(context)
                                      : defaultAccentLightColor_(context),
                                  onPressed: () {
                                    if (controller.isSaveEnable.value) {
                                      if (controller.addressDetailsInfo !=
                                          null) {
                                        controller.updateAddressApi();
                                      } else {
                                        controller.addAddressApi();
                                      }
                                    }
                                  }),
                            )
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
