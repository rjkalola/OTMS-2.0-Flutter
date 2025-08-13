import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

class PendingForApprovalView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'billing_information_submission_is_pending_for_approval'.tr,
          style:
          TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ) ,
    );
  }
}