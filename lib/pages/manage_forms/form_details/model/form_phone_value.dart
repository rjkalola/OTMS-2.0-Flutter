import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';

class FormPhoneValue {
  FormPhoneValue({
    this.extensionId = AppConstants.defaultPhoneExtensionId,
    this.extension = AppConstants.defaultPhoneExtension,
    this.flag = AppConstants.defaultFlagUrl,
    this.phone = '',
  });

  int extensionId;
  String extension;
  String flag;
  String phone;

  bool get isEmpty => StringHelper.isEmptyString(phone.trim());
}
