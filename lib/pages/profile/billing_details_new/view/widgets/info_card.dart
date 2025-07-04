import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/address_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/email_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/first_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/last_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/middle_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/phone_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/postcode_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/title_text.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import '../../../../authentication/login/view/widgets/phone_extension_field_widget.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;
  const InfoCard({this.label = "", required this.value, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8,offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(label, style: TextStyle(color:Color(0xff999999), fontSize: 16,fontWeight: FontWeight.w400)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                color: isLink ? blueBGButtonColor : Colors.black,
                fontWeight: FontWeight.w400,fontSize: 16),
          ),
        ],
      ),
    );
  }
}