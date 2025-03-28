import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/custom_views/dotted_line_vertical_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class CheckInAddressesListView extends StatelessWidget {
  const CheckInAddressesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(), //
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: List.generate(
          3,
          (position) => InkWell(
            onTap: () {},
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: CustomPaint(
                                size: Size(1.3, double.infinity),
                                painter: DottedLineVerticalWidget()),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: position != 2
                                ? CustomPaint(
                                    size: Size(1.3, double.infinity),
                                    painter: DottedLineVerticalWidget())
                                : Container(),
                          )
                        ],
                      ),
                      Visibility(
                        visible: position != 2,
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: Center(
                            child: CircleWidget(
                              color: position == 1
                                  ? Colors.green
                                  : Colors.grey.shade400,
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: position == 2,
                        child: ImageUtils.setAssetsImage(
                            Drawable.addCreateNewPlusIcon,
                            22,
                            22,
                            BoxFit.cover,
                            primaryTextColor),
                      )
                    ],
                  ),
                  position != 2
                      ? Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8, top: 7, bottom: 7),
                            padding: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              boxShadow: [
                                AppUtils.boxShadow(Colors.grey.shade300, 6)
                              ],
                              border: Border.all(
                                  width: 0.6,
                                  color: position == 1
                                      ? Color(0xff2DC75C)
                                      : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        setProjectTextView(position == 1
                                            ? "Haringey OT Haringey OT Haringey OT"
                                            : "Haringey OT"),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        setProjectTextView("Day work")
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: dividerColor,
                                  width: 1,
                                  height: 50,
                                ),
                                Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: PrimaryTextView(
                                      textAlign: TextAlign.center,
                                      text: "06:00",
                                      fontSize: 22,
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.w600,
                                    )),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                  weight: 300,
                                )
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: SizedBox(
                            height: 90,
                          ),
                        ),
                  SizedBox(
                    width: 16,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget setProjectTextView(String? text) => Container(
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            color: Color(0xffD5DDF2), borderRadius: BorderRadius.circular(4)),
        child: PrimaryTextView(
          text: text ?? "",
          fontSize: 14,
          color: primaryTextColor,
          fontWeight: FontWeight.w500,
          softWrap: true,
        ),
      );
}
