import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class SelectorCard extends StatelessWidget {
  final String placeholder;
  final String text;

  const SelectorCard({
    super.key,
    required this.placeholder,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the text is empty or null to decide if we show the placeholder
    final bool isPlaceholder = text.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor_(context), // Using your custom color function
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              isPlaceholder ? placeholder : text,
              style: TextStyle(
                fontSize: 16,
                // If it's a placeholder, use the theme's hintColor (default placeholder color)
                color: isPlaceholder
                    ? Theme.of(context).hintColor
                    : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Theme.of(context).hintColor.withOpacity(0.5), // Match arrow to theme
          ),
        ],
      ),
    );
  }
}