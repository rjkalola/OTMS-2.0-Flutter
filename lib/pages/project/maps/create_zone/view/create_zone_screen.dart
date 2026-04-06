import 'package:belcka/pages/project/maps/create_zone/controller/create_zone_controller.dart';
import 'package:belcka/pages/profile/post_coder_search/model/post_coder_model.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/slider/custom_slider.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateZoneScreen extends StatefulWidget {
  const CreateZoneScreen({super.key});

  @override
  State<CreateZoneScreen> createState() => _CreateZoneScreenState();
}

class _CreateZoneScreenState extends State<CreateZoneScreen> {
  final CreateZoneController controller = Get.put(CreateZoneController());
  bool _accentApplied = false;

  void _searchAddress() {
    FocusScope.of(context).unfocus();
    final txt = controller.searchAddressController.value.text.trim();
    if (txt.isNotEmpty) {
      controller.lookupAddress(txt);
    }
  }

  void _openColorPicker() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('zone_color'.tr),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: controller.zoneColor.value,
              onColorChanged: controller.onZoneColorChanged,
              enableAlpha: false,
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.72,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('done'.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    if (!_accentApplied) {
      _accentApplied = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.applyDefaultAccentIfNeeded(context);
      });
    }

    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: controller.title.value,
                isCenterTitle: false,
                isBack: true,
                bgColor: dashBoardBgColor_(context),
              ),
              body: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFieldBorderDark(
                        textEditingController: controller.nameController,
                        labelText: 'name'.tr,
                        hintText: 'name'.tr,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'required_field'.tr),
                        ]),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropDownTextField(
                        title: 'select_project'.tr,
                        controller: controller.projectController,
                        isArrowHide: false,
                        onPressed: controller.showSelectProjectDialog,
                        validators: [
                          RequiredValidator(errorText: 'required_field'.tr),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: SearchTextFieldDark(
                                controller: controller.searchAddressController,
                                isClearVisible: controller.isClearVisible,
                                onValueChange: controller.onSearchChanged,
                                onPressedClear: controller.clearSearch,
                                label: 'search_location'.tr,
                                hint: 'search_location_hint'.tr,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _searchAddress,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: defaultAccentColor_(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 0),
                            ),
                            child: Text(
                              'search'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _addressResultsList(context),
                    Obx(() {
                      if (!controller.showRadiusSlider) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TitleTextView(
                              text:
                                  "${'area_size'.tr} (${controller.circleRadiusMeters.value} Meter)",
                              maxLine: 2,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomSlider(
                                progress: controller.circleRadiusMeters,
                                min: 10,
                                max: 10000,
                                onChanged: controller.onCircleRadiusChanged,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                CustomMapView(
                                  onMapCreated: controller.onMapCreated,
                                  target: controller.selectedLatLng,
                                  markers: controller.mapMarkers,
                                  circles: controller.mapCircles,
                                  polygons: controller.mapPolygons,
                                  polylines: controller.mapPolylines,
                                  initialZoom: 15,
                                  onCameraMove: controller.onCameraMove,
                                  onCameraIdle: controller.onCameraIdle,
                                  onTap: controller.onMapTap,
                                ),
                                Obx(() {
                                  if (!controller.showCenterPin) {
                                    return const SizedBox.shrink();
                                  }
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.location_on,
                                      size: 45,
                                      color: defaultAccentColor_(context),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          _mapToolbar(context),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (controller.drawTool.value != ZoneDrawTool.polygon ||
                          controller.hasCompletePolygon) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 18, color: defaultAccentColor_(context)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'polygon_draw_hint'.trParams({
                                  'pts': '${controller.polygonPoints.length}',
                                }),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryTextColor_(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TitleTextView(text: 'zone_color'.tr),
                          const SizedBox(width: 8),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _openColorPicker,
                              borderRadius: BorderRadius.circular(4),
                              child: Obx(
                                () => Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: controller.zoneColor.value,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: secondaryLightTextColor_(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryBorderButton(
                              buttonText: 'cancel'.tr,
                              fontWeight: FontWeight.w400,
                              borderColor: secondaryExtraLightTextColor_(context),
                              fontColor: secondaryTextColor_(context),
                              onPressed: () => Get.back<void>(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              buttonText: 'save'.tr,
                              fontWeight: FontWeight.w400,
                              color: defaultAccentColor_(context),
                              onPressed: () => controller.save(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Inline below the search row (not over the map).
  Widget _addressResultsList(BuildContext context) {
    return Obx(
      () {
        if (controller.addressList.isEmpty) {
          return const SizedBox.shrink();
        }
        final maxH = MediaQuery.sizeOf(context).height * 0.28;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: CardViewDashboardItem(
            margin: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxH),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: controller.addressList.length,
                itemBuilder: (context, index) {
                  final PostCoderModel place = controller.addressList[index];
                  return ListTile(
                    dense: true,
                    title: Text(place.summaryline ?? ''),
                    onTap: () {
                      controller.selectPlace(
                        place.postcode ?? '',
                        place.summaryline ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mapToolbar(BuildContext context) {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Obx(
          () => CardViewDashboardItem(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                _toolIcon(
                  context,
                  icon: Icons.pan_tool_alt_outlined,
                  selected: controller.drawTool.value == ZoneDrawTool.pan,
                  onTap: () => controller.setDrawTool(ZoneDrawTool.pan),
                ),
                _toolIcon(
                  context,
                  icon: Icons.pentagon_outlined,
                  selected: controller.drawTool.value == ZoneDrawTool.polygon,
                  onTap: () => controller.setDrawTool(ZoneDrawTool.polygon),
                ),
                _toolIcon(
                  context,
                  icon: Icons.circle_outlined,
                  selected: controller.drawTool.value == ZoneDrawTool.circle,
                  onTap: () => controller.setDrawTool(ZoneDrawTool.circle),
                ),
                // if (controller.drawTool.value == ZoneDrawTool.polygon &&
                //     controller.polygonPoints.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 8),
                //     child: Text(
                //       '${controller.polygonPoints.length} pts',
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: defaultAccentColor_(context),
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolIcon(
    BuildContext context, {
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        size: 22,
        color: selected
            ? defaultAccentColor_(context)
            : primaryTextColor_(context),
      ),
      onPressed: onTap,
    );
  }
}
