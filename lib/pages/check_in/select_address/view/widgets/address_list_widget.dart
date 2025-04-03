import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class AddressListWidget extends StatelessWidget {
  const AddressListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        //
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, position) => Divider(
          color: dividerColor,
        ),
        itemBuilder: (context, position) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: primaryTextColor,
                      softWrap: true,
                      text:
                          "	Unit 6, Woolwich Trademan Park, Pettman Cre scen",
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  CircleWidget(color: Colors.red, width: 13, height: 13)
                ],
              ),
            ),
          );
        },
        itemCount: 15,
      ),
    );
  }
}
