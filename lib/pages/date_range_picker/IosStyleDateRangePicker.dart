import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/date_range_picker/DateRangeController.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class IosStyleDateRangePicker extends StatelessWidget {
  final DateRangeController controller = Get.put(DateRangeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("iOS Style Date Picker")),
      body: Column(
        children: [
          SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            todayHighlightColor: CupertinoColors.systemBlue,
            startRangeSelectionColor: CupertinoColors.systemBlue,
            endRangeSelectionColor: CupertinoColors.systemBlue,
            rangeSelectionColor: CupertinoColors.systemBlue.withOpacity(0.25),
            selectionTextStyle: TextStyle(color: Colors.white),
            onSubmit: (value) {
              if (value is PickerDateRange) {
                controller.setRange(value);
              }
              Get.back(); // close if in modal
            },
            onCancel: () {
              controller.clearRange();
              Get.back();
            },
          ),
          Obx(() {
            final range = controller.selectedRange.value;
            if (range == null) return Text("No date selected");

            final start = range.startDate?.toLocal().toString().split(' ')[0];
            final end = range.endDate?.toLocal().toString().split(' ')[0];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Selected: $start → $end"),
            );
          }),
        ],
      ),
    );
  }
}
