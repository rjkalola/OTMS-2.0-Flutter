import 'package:belcka/pages/profile/post_coder_search/model/post_coder_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/post_coder_search/controller/post_coder_search_repository.dart';

class PostCoderSearchController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isInternetNotAvailable = false.obs;
  RxBool isMainViewVisible = false.obs;
  final api = PostCoderSearchRepository();
  var addressList = <PostCoderModel>[].obs;
  var headerText = "".obs;
  var nextPage = 0.obs;
  String initialPostcode = "";
  final postCodeFieldController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    var arguments = Get.arguments;
    if (arguments != null) {
      initialPostcode = arguments["post_code"] ?? "";
      if (initialPostcode.isNotEmpty) {
        postCodeFieldController.value.text = initialPostcode.trim();
        lookupAddress(initialPostcode.trim());
      }
    }
  }
  Future<void> lookupAddress(String postcode) async {
    try {
      isLoading.value = true;
      headerText.value = "";
      addressList.clear();
      final result = await api.getAddresses(
        postcode: postcode,
        page: 0,
        countryCode: "GB",
      );
      print("PARSED LIST = ${result.length}");
      addressList.value = result;
      headerText.value = "${result.length} addresses found";
    } catch (e) {
      print("Error: $e");
      if (e == "noResultsFound") {
        headerText.value = "No addresses found";
      } else {
        headerText.value = "An error occurred";
      }
      addressList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}