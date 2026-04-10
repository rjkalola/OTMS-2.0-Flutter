import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class SelectorCard extends StatelessWidget {
  final String placeholder;
  final String text;
  final bool isOpen;
  final VoidCallback onTap;

  const SelectorCard({
    super.key,
    required this.placeholder,
    required this.text,
    required this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder = text.isEmpty;
    final Color activeColor = defaultAccentColor_(context);
    final Color borderColor = isOpen ? activeColor : Colors.black12;

    return GestureDetector(
      onTap: onTap, // Trigger the dropdown
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isOpen ? 1.5 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isPlaceholder ? placeholder : text,
                style: TextStyle(
                  fontSize: 15,
                  color: isPlaceholder ? secondaryTextColor_(context): primaryTextColor_(context),
                ),
              ),
            ),
            Icon(
              isOpen ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp,
              size: 25,
              color: isOpen ? activeColor : secondaryTextColor_(context),
            ),
          ],
        ),
      ),
    );
  }
}