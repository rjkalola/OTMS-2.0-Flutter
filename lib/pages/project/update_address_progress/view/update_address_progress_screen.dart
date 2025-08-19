import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/project/address_details/model/address_details_info.dart';
import 'package:otm_inventory/pages/project/update_address_progress/controller/update_address_progress_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class UpdateAddressProgressScreen extends StatefulWidget {
  final AddressDetailsInfo addressDetailsInfo;

  const UpdateAddressProgressScreen(
      {Key? key, required this.addressDetailsInfo})
      : super(key: key);

  @override
  _UpdateAddressProgressScreenState createState() =>
      _UpdateAddressProgressScreenState();
}

class _UpdateAddressProgressScreenState
    extends State<UpdateAddressProgressScreen> {
  late final UpdateAddressProgressController controller;

  @override
  void initState() {
    super.initState();
    controller = UpdateAddressProgressController(
      addressDetailsInfo: widget.addressDetailsInfo,
    );
    controller.selectedStatus = widget.addressDetailsInfo.statusText ?? "";
    String serverProgress = widget.addressDetailsInfo.progress ?? "";
    controller.progress =
        double.tryParse(serverProgress.replaceAll('%', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Status Dropdown
          Align(
            alignment: Alignment.centerLeft,
            child:
                Text("status".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: primaryTextColor_(context)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedStatus,
                isExpanded: true,
                items: controller.status.keys.map((key) {
                  return DropdownMenuItem(value: key, child: Text(key));
                }).toList(),
                onChanged: (value) =>
                    setState(() => controller.selectedStatus = value!),
              ),
            ),
          ),

          SizedBox(height: 24),
          // Progress Slider
          Align(
            alignment: Alignment.centerLeft,
            child:
                Text("progress".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: controller.progress,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '${controller.progress.toInt()}%',
                  onChanged: (value) =>
                      setState(() => controller.progress = value),
                ),
              ),
              Text("${controller.progress.toInt()}%"),
            ],
          ),
          SizedBox(height: 20),
          // Save Button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
                padding: EdgeInsets.fromLTRB(14, 16, 14, 16),
                buttonText: 'save'.tr,
                color: defaultAccentColor_(context),
                onPressed: () {
                  controller.selectedStatusValue =
                      controller.status[controller.selectedStatus]!;
                  controller.onSavePressed(context);
                }),
          ),
        ],
      ),
    );
  }
}
