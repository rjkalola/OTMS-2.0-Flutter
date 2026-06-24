import 'package:belcka/res/colors.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectShiftDialog extends StatelessWidget {
  final String selectedProjectName;
  final List<ModuleInfo> shifts;
  final ValueChanged<ModuleInfo> onShiftSelected;
  final VoidCallback onBack;

  const SelectShiftDialog({
    super.key,
    required this.selectedProjectName,
    required this.shifts,
    required this.onShiftSelected,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: dividerColor_(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'project_selected'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor_(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedProjectName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor_(context),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onBack,
                  child: Text(
                    'change'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: defaultAccentColor_(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'select_shift'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryTextColor_(context),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: shifts.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: dividerColor_(context),
            ),
            itemBuilder: (context, index) {
              final shift = shifts[index];
              return InkWell(
                onTap: () => onShiftSelected(shift),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          shift.name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: primaryTextColor_(context),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: secondaryTextColor_(context),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPad + 16),
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF484B),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF484B).withOpacity(0.62),
                      blurRadius: 10,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'back'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
