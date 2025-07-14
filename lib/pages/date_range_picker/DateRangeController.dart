import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeController extends GetxController {
  final selectedRange = Rxn<PickerDateRange>();

  void setRange(PickerDateRange range) {
    selectedRange.value = range;
  }

  void clearRange() {
    selectedRange.value = null;
  }
}
