import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/week_day_info.dart';
import 'package:otm_inventory/res/colors.dart';

class WeekDaysList extends StatelessWidget {
  WeekDaysList({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
          spacing: 12,
          children: List.generate(controller.weekDaysList.length, (index) {
            WeekDayInfo info = controller.weekDaysList[index];
            return GestureDetector(
              onTap: () {
                info.status = !info.status!;
                controller.isSaveEnable.value = true;
                controller.weekDaysList.refresh();
              },
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: info.status! ? defaultAccentColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: info.status!
                        ? defaultAccentColor
                        : Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                child: Text(
                  info.name!.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: info.status! ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          })),
    );
  }
}
