import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/phone_extension_textfield_company_sign_up.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/widgets/phone_number_textfield_company_signup.dart';

class PhoneNumberViewCompanySignUp extends StatelessWidget {
  const PhoneNumberViewCompanySignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 6,
            child: PhoneExtensionTextFieldCompanySignUp(),
          ),
          SizedBox(
            width: 12,
          ),
          Flexible(flex: 9, child: PhoneNumberTextFieldCompanySignup()),
        ],
      ),
    );
  }
}
