import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/phone_extension_textfield_company_sign_up.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/phone_number_textfield_company_signup.dart';

class PhoneNumberViewCompanySignUp extends StatelessWidget {
  const PhoneNumberViewCompanySignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: PhoneExtensionTextFieldCompanySignUp(),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(flex: 3, child: PhoneNumberTextFieldCompanySignup()),
        ],
      ),
    );
  }
}
