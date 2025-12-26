import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/update_address_progress/controller/update_address_progress_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateAddressProgressScreen extends StatefulWidget {
  final AddressInfo addressDetailsInfo;

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
    // Extract server-provided status
    String serverStatus = widget.addressDetailsInfo.statusText ?? "";
    // Validate it against the dropdown keys
    if (controller.status.containsKey(serverStatus)) {
      controller.selectedStatus = serverStatus;
    }
    else{
      // Default to To Do if invalid
      controller.selectedStatus = "To Do";
    }
    controller.selectedStatusValue = widget.addressDetailsInfo.statusInt ?? 0;
    // Handle progress parsing safely
    String serverProgress = widget.addressDetailsInfo.progress ?? "";
    controller.progress =
        double.tryParse(serverProgress.replaceAll('%', '')) ?? 0.0;
  }
  @override
  Widget build(BuildContext context) {
    final status =
    controller.determineStatusTextFromProgress(controller.progress);
    final isTodo = status == "To Do";

    return Obx(() => Container(
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
        /*
          Align(
            alignment: Alignment.centerLeft,
            child: Text("status".tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
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
          */
          //SizedBox(height: 24),
          // Progress Slider
          Align(
            alignment: Alignment.centerLeft,
            child: Text("change_progress".tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
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
              //Text("${controller.progress.toInt()}%"),
            ],
          ),
          Row(
            children: [
              if (!isTodo) const Spacer(),
              Text(
                isTodo
                    ? status
                    : "$status (${controller.progress.toInt()}%)",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: controller.getStatusColor(controller.progress),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Save Button
          Visibility(
            visible: !controller.isUpdating.value,
            child: SizedBox(
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
          ),
          Visibility(
            visible: controller.isUpdating.value,
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                  padding: EdgeInsets.fromLTRB(14, 16, 14, 16),
                  buttonText: 'updating'.tr,
                  color: Colors.grey,
                  onPressed: () {

                  }),
            ),
          ),
        ],
      ),
    ));
  }
}
