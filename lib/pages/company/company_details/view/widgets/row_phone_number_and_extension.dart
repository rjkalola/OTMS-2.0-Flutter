import 'package:flutter/material.dart';
import 'package:belcka/pages/company/company_details//view/widgets/text_field_phone_extension.dart';
import 'package:belcka/pages/company/company_details/view/widgets/text_field_phone_number.dart';

class RowPhoneNumberAndExtension extends StatelessWidget {
  const RowPhoneNumberAndExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: TextFieldPhoneExtension(),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(flex: 3, child: TextFieldPhoneNumber()),
        ],
      ),
    );
  }
}
