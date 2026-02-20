import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassSegmentedControl extends StatefulWidget {
  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onChanged;

  const LiquidGlassSegmentedControl({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onChanged,
  });

  @override
  State<LiquidGlassSegmentedControl> createState() =>
      _LiquidGlassSegmentedControlState();
}

class _LiquidGlassSegmentedControlState
    extends State<LiquidGlassSegmentedControl> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white.withOpacity(0.25),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth =
                  constraints.maxWidth / widget.items.length;

              return Stack(
                children: [
                  /// Selected pill
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    left: selectedIndex * segmentWidth,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white.withOpacity(0.85),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Labels
                  Row(
                    children: List.generate(widget.items.length, (index) {
                      final isSelected = index == selectedIndex;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() => selectedIndex = index);
                            widget.onChanged(index);
                          },
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.45),
                              ),
                              child: Text(widget.items[index]),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
