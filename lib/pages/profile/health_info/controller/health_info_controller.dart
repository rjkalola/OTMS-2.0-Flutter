import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class HealthInfoController extends ChangeNotifier {
  // Emergency Contact Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final postCodeController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  // Health Info Controllers
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // Health Conditions State
  final Map<String, bool?> conditions = {
    "Heart trouble / Blood pressure": null,
    "Asthma / Bronchitis": null,
    "Diabetes": null,
    "Epilepsy / Fainting": null,
    "Migraine": null,
    "Severe Head Injury": null,
    "Cancer": null,
    "Back Problems": null,
    "Allergies": null,
    "Fractures / Ligament damage": null,
    "Physical disability": null,
    "Psychiatric illness": null,
    "Hospitalised (last 2 years)": null,
    "Infectious diseases": null,
    "Registered disabled": null,
    "Blind / Impaired eyesight": null,
    "Hearing problems": null,
    "Other health issues": null,
  };

  bool isAgreed = false;

  void updateCondition(String key, bool? value) {
    conditions[key] = value;
    notifyListeners();
  }

  void toggleAgreement(bool? value) {
    isAgreed = value ?? false;
    notifyListeners();
  }

  void submitForm() {
    // Implement your submission logic here
    print("Form Submitted: ${firstNameController.text}");
  }

  @override
  void dispose() {
    // Clean up controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    postCodeController.dispose();
    addressController.dispose();
    phoneController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }
  void onBackPress() {
    Get.back(result: true);
  }
}