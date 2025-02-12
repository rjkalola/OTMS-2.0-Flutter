import 'package:form_field_validator/form_field_validator.dart';

class CustomFieldValidator extends FieldValidator<String> {
  final bool Function(String?) validationFunction;

  CustomFieldValidator(this.validationFunction, { required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) => validationFunction(value);

  @override
  String? call(String? value) => isValid(value) ? null : errorText;
}

// class CustomFieldValidator extends FieldValidator<String> {
//   final String? Function(String?) validationFunction;
//
//   CustomFieldValidator(this.validationFunction) : super("");
//
//   @override
//   bool isValid(String? value) => validationFunction(value) == null;
//
//   @override
//   String? call(String? value) => validationFunction(value); // ✅ Returns dynamic error messages
// }