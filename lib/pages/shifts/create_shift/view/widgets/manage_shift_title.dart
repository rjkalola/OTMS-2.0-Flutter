import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/shift_name_textfield.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/shift_type.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

class ManageShiftTitle extends StatelessWidget {
  const ManageShiftTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          children: [
            ShiftNameTextField(),
            ShiftType(),
          ],
        ));
  }
}
