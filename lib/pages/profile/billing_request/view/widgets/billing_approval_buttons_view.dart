import 'package:belcka/widgets/buttons/approve_reject_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:belcka/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class BillingApprovalButtonsView extends StatefulWidget {
  @override
  _BillingApprovalButtonsViewState createState() => _BillingApprovalButtonsViewState();
}

class _BillingApprovalButtonsViewState extends State<BillingApprovalButtonsView> {

  final TextEditingController _noteController = TextEditingController();
  final controller = Get.put(BillingRequestController());
  final bool showActionCard = UserUtils.isAdmin();//true; // Change to false for second scenario

  bool showNoteSection = false;
  String selectedAction = ''; // To know whether approve or reject was clicked

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: showActionCard
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "this_billing_data_is_awaiting_for_approval".tr,
            style: TextStyle(color: Colors.grey.shade600,fontSize: 15),
          ),
          SizedBox(height: 8),

          if (showNoteSection) ...[
            Text("do_you_want_to_leave_a_note".tr, style: TextStyle(color: Colors.grey.shade600)),
            SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "enter_note".tr,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
          SizedBox(height: 12),

          ApproveRejectButtons(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
              onClickApprove: (){
                if (selectedAction == "approve"){
                  print("Approved: ${_noteController.text}");
                  controller.approveRequest();
                }
                else{
                  setState(() {
                    showNoteSection = true;
                    selectedAction = 'approve';
                  }
                  );
                }
              },
              onClickReject: () {
                if (selectedAction == "reject"){
                  print("Rejected: ${_noteController.text}");
                  controller.rejectRequest(_noteController.text ?? "");
                }
                else{
                  setState(() {
                    showNoteSection = true;
                    selectedAction = 'reject';
                  });
                }
              })
        ],
      )
          : Center(
        child: Text(
          "billing_information_submission_is_pending_for_approval".tr,
          style:
          TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}