import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';

class CheckInOutDisplayNoteWidget extends StatelessWidget {
  CheckInOutDisplayNoteWidget(
      {super.key, this.note, this.labelText, this.padding});

  final String? note, labelText;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !StringHelper.isEmptyString(note),
      child: Padding(
        padding: padding ?? EdgeInsets.fromLTRB(6, 16, 6, 0),
        // child: TextFieldBorder(
        //   textEditingController: TextEditingController(text: note),
        //   hintText: labelText ?? "",
        //   labelText: labelText ?? "",
        //   textInputAction: TextInputAction.newline,
        //   validator: MultiValidator([]),
        //   isReadOnly: true,
        //   textAlignVertical: TextAlignVertical.top,
        //   // onValueChange: null,
        //   borderRadius: 16,
        // ),
        child: SizedBox(
          width: double.infinity,
          child: RichText(
              // textAlign: TextAlign.justify,
              text: TextSpan(
            text: "${labelText ?? ""}: ",
            style: TextStyle(
                fontSize: 16,
                color: primaryTextColor_(context),
                fontWeight: FontWeight.w500),
            children: <TextSpan>[
              TextSpan(
                  text: note ?? "",
                  style: TextStyle(
                      fontSize: 16,
                      color: secondaryLightTextColor_(context),
                      fontWeight: FontWeight.w400)),
            ],
          )),
        ),
      ),
    );
  }
}
