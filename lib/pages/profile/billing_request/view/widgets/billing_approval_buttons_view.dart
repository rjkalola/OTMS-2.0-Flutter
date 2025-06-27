import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:otm_inventory/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:otm_inventory/res/colors.dart';

class BillingApprovalButtonsView extends StatelessWidget {

  final TextEditingController _noteController = TextEditingController();
  final controller = Get.put(BillingRequestController());

  final bool showActionCard = true; // Change to false for second scenario

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: showActionCard
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This billing data is awaiting for approval.",
            style: TextStyle(color: Colors.grey.shade600,fontSize: 15),
          ),
          SizedBox(height: 8),
          Text("Note :", style: TextStyle(color: Colors.grey.shade600)),
          SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter note",
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  print("Approved: ${_noteController.text}");
                  controller.approveRequest();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: defaultAccentColor),
                  foregroundColor: defaultAccentColor,
                  textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
                child: Text("Approve"),
              ),
              OutlinedButton(
                onPressed: () {
                  print("Rejected: ${_noteController.text}");
                  controller.rejectRequest(_noteController.text ?? "");
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
                child: Text("Reject"),
              ),
            ],
          ),
        ],
      )
          : Center(
        child: Text(
          "Billing information submission is pending for approval.",
          style:
          TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}