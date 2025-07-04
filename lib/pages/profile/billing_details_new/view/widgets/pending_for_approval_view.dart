import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PendingForApprovalView extends StatelessWidget {

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
      child: Center(
        child: Text(
          "Billing information submission is pending for approval.",
          style:
          TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ) ,
    );
  }
}