import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FormLocationFieldView extends StatefulWidget {
  const FormLocationFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  State<FormLocationFieldView> createState() => _FormLocationFieldViewState();
}

class _FormLocationFieldViewState extends State<FormLocationFieldView> {
  late final FormDetailsController _controller;
  late final String _fieldId;
  GoogleMapController? _mapController;
  late final TextEditingController _manualController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FormDetailsController>();
    _fieldId = widget.field.id ?? '';
    _manualController = TextEditingController(
      text: _controller.getManualLocationInput(_fieldId),
    );
    _manualController.addListener(_onManualInputChanged);
  }

  void _onManualInputChanged() {
    _controller.setManualLocationInput(_fieldId, _manualController.text);
  }

  @override
  void dispose() {
    _manualController.removeListener(_onManualInputChanged);
    _manualController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _moveMapCamera(double latitude, double longitude) async {
    final mapController = _mapController;
    if (mapController == null) return;

    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        _controller.locationValues[_fieldId];
        _controller.locationLoading[_fieldId];

        final hasError = _controller.showValidationErrors.value &&
            _controller.isFieldInvalid(_fieldId);
        final isManual = widget.field.isManualLocation;

        return CardViewDashboardItem(
          borderRadius: widget.isNested ? 12 : 16,
          margin: widget.isNested
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormFieldLabel(
                label: widget.field.label ?? '',
                isRequired: widget.field.isRequired,
              ),
              if (!StringHelper.isEmptyString(widget.field.description)) ...[
                const SizedBox(height: 4),
                SubtitleTextView(
                  text: widget.field.description!,
                  fontSize: 14,
                  color: secondaryExtraLightTextColor_(context),
                  maxLine: 4,
                ),
              ],
              const SizedBox(height: 12),
              if (isManual)
                _ManualLocationInput(
                  controller: _manualController,
                )
              else
                _CurrentLocationSection(
                  fieldId: _fieldId,
                  controller: _controller,
                  onMapCreated: (mapController) {
                    _mapController = mapController;
                    final value = _controller.getLocationValue(_fieldId);
                    if (value?.hasCurrentCoordinates == true) {
                      _moveMapCamera(value!.latitude!, value.longitude!);
                    }
                  },
                  onLocationUpdated: _moveMapCamera,
                ),
              if (hasError && widget.field.isRequired) ...[
                const SizedBox(height: 6),
                Text(
                  'this_field_is_required'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: rejectTextColor_(context),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CurrentLocationSection extends StatelessWidget {
  const _CurrentLocationSection({
    required this.fieldId,
    required this.controller,
    required this.onMapCreated,
    required this.onLocationUpdated,
  });

  final String fieldId;
  final FormDetailsController controller;
  final ValueChanged<GoogleMapController> onMapCreated;
  final Future<void> Function(double latitude, double longitude) onLocationUpdated;

  @override
  Widget build(BuildContext context) {
    final value = controller.getLocationValue(fieldId);
    final hasLocation = value?.hasCurrentCoordinates == true;
    final isLoading = controller.isLocationLoading(fieldId);

    if (!hasLocation) {
      return _LocationActionButton(
        label: 'add_location'.tr,
        isLoading: isLoading,
        onPressed: () => controller.fetchCurrentLocation(fieldId),
      );
    }

    final latitude = value!.latitude!;
    final longitude = value.longitude!;
    final accuracy = value.accuracyMeters;
    final markerPosition = LatLng(latitude, longitude);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: dividerColor_(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CoordinateLine(
                            label: 'latitude'.tr,
                            value: latitude.toString(),
                          ),
                          const SizedBox(height: 4),
                          _CoordinateLine(
                            label: 'longitude'.tr,
                            value: longitude.toString(),
                          ),
                          if (accuracy != null) ...[
                            const SizedBox(height: 4),
                            _CoordinateLine(
                              label: 'accuracy'.tr,
                              value: '${accuracy.round()}m',
                            ),
                          ],
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: isLoading
                          ? null
                          : () async {
                              await controller.fetchCurrentLocation(fieldId);
                              final updated = controller.getLocationValue(fieldId);
                              if (updated?.hasCurrentCoordinates == true) {
                                await onLocationUpdated(
                                  updated!.latitude!,
                                  updated.longitude!,
                                );
                              }
                            },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: secondaryExtraLightTextColor_(context),
                                ),
                              )
                            : Icon(
                                Icons.sync,
                                size: 20,
                                color: secondaryExtraLightTextColor_(context),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: GoogleMap(
                    onMapCreated: (mapController) {
                      onMapCreated(mapController);
                      mapController.moveCamera(
                        CameraUpdate.newLatLngZoom(markerPosition, 15),
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: markerPosition,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(fieldId),
                        position: markerPosition,
                      ),
                    },
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _LocationActionButton(
          label: 'update_location'.tr,
          isLoading: isLoading,
          onPressed: () async {
            await controller.fetchCurrentLocation(fieldId);
            final updated = controller.getLocationValue(fieldId);
            if (updated?.hasCurrentCoordinates == true) {
              await onLocationUpdated(updated!.latitude!, updated.longitude!);
            }
          },
        ),
      ],
    );
  }
}

class _ManualLocationInput extends StatelessWidget {
  const _ManualLocationInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: primaryTextColor_(context),
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'latitude_longitude'.tr,
            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: hintColor_(context),
            ),
            contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: normalTextFieldBorderColor_(context),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: normalTextFieldBorderColor_(context),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: focusedTextFieldBorderColor_(context),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SubtitleTextView(
          text: 'location_coordinates_example'.tr,
          fontSize: 13,
          color: secondaryExtraLightTextColor_(context),
        ),
      ],
    );
  }
}

class _CoordinateLine extends StatelessWidget {
  const _CoordinateLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          height: 1.3,
          color: primaryTextColor_(context),
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _LocationActionButton extends StatelessWidget {
  const _LocationActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: dividerColor_(context)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const StadiumBorder(),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: accentColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUtils.setSvgAssetsImage(
                    path: Drawable.mapPinIcon,
                    width: 18,
                    height: 18,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
