import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/post_coder_search/controller/post_coder_search_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../../widgets/textfield/text_field_underline_.dart';

class PostCoderSearchScreen extends StatefulWidget {
  @override
  _PostCoderSearchScreenState createState() => _PostCoderSearchScreenState();
}
class _PostCoderSearchScreenState extends State<PostCoderSearchScreen>{
  final controller = Get.put(PostCoderSearchController());

  final TextEditingController _controller = TextEditingController();
  List<String> addressResults = [];

  void _search() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        addressResults = [
          "WN3 4AA\n123-125 Wallgate, Wigan, Lancashire",
          "ME14 1FY\nFlat 123, Brenchley House, 123-135 Week Street, Maidstone",
          "B79 7QA\nCouncil, 120-123 Lichfield Street, Tamworth",
          "B91 1HT\nPost Office, 121-123 Prospect Lane, Solihull",
          "B91 3SR\n123-127 High Street, Solihull",
          "BS23 1HN\n119-123 High Street, Weston-Super-Mare",
          "BS30 8TP\n121-123 North Street, Oldland Common, Bristol",
          "BS2 9LU\n121-123 Newfoundland Road, Bristol",
          "BS3 2SZ\n123-125 South Liberty Lane, Bristol",
          "BS5 7NQ\nFlat A, 121-123 Bell Hill Road, Bristol"
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor,
        child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: "Search Post Code",
                isCenterTitle: false,
                bgColor: dashBoardBgColor,
                isBack: true
              ),
              backgroundColor: dashBoardBgColor,
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const Center(
                  child: Text("No Internet"),
                )
                    :  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldUnderline(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textEditingController: _controller,
                          hintText: "Postcode or address",
                          labelText: "Postcode or address",
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onValueChange: (value) {
                            //controller.onValueChange();
                          },
                          onPressed: () {},
                          validator: MultiValidator([
                          ]),
                          inputFormatters: <TextInputFormatter>[
                          ]),
                      SizedBox(height: 24),
                      SizedBox(
                        height: 35,
                        width: 86,
                        child: OutlinedButton(
                          onPressed: () {
                            _search();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color:blueBGButtonColor,
                                width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'search'.tr,
                            style: TextStyle(color: blueBGButtonColor,fontSize: 15,fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      if (addressResults.isNotEmpty)
                        Text("${addressResults.length} addresses found",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: addressResults.length,
                          separatorBuilder: (_, __) => Divider(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context, addressResults[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(addressResults[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))));
  }
}