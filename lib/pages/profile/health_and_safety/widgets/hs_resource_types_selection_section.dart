import 'package:belcka/pages/profile/health_and_safety/widgets/selector_card.dart';
import 'package:flutter/material.dart';

class HsResourceTypesSelectionSection extends StatefulWidget {
  const HsResourceTypesSelectionSection({super.key});

  @override
  State<HsResourceTypesSelectionSection> createState() => _HsResourceTypesSelectionSectionState();
}

class _HsResourceTypesSelectionSectionState extends State<HsResourceTypesSelectionSection> {
  String selectedHazard = "";
  bool isDropdownOpen = false;

  final List<String> hazardOptions = [
    "Chemical exposure",
    "Health hazard",
    "Physical hazard",
    "Safety hazard",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hazard Type", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // The Card
        SelectorCard(
          placeholder: "Select Hazard Type",
          text: selectedHazard,
          isOpen: isDropdownOpen,
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
        ),

        // The Dropdown Menu (Appears below)
        if (isDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: hazardOptions.map((option) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedHazard = option;
                      isDropdownOpen = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}