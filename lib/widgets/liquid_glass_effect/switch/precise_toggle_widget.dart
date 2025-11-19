import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

/// ---------- PreciseToggle with subtle liquid-glass effects ----------
class PreciseToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor, activeCircleColor;
  const PreciseToggle({super.key, required this.value, required this.onChanged,
    required this.activeColor, required this.activeCircleColor});

  @override
  State<PreciseToggle> createState() => _PreciseToggleState();
}

class _PreciseToggleState extends State<PreciseToggle> with TickerProviderStateMixin {
  static const double _trackWidth = 50; // overall control width
  static const double _trackHeight = 25; // grey track height
  static const double _thumbW = 32; // white thumb width (oval)
  static const double _thumbH = 25; // white thumb height (oval)
  static const double _padding = 0; // inside horizontal padding

  late bool _val;
  late AnimationController _anim;

  // press/squish animation controller (0..1)
  late AnimationController _pressAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    if (_val) _anim.value = 1; else _anim.value = 0;

    _pressAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 120), lowerBound: 0, upperBound: 1);
    _pressAnim.value = 0;
  }

  @override
  void didUpdateWidget(covariant PreciseToggle old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _val = widget.value;
      if (_val) _anim.forward(); else _anim.reverse();
    }
  }

  void _toggle() {
    _val = !_val;
    widget.onChanged(_val);
    if (_val) _anim.forward(); else _anim.reverse();
  }

  void _onTapDown(_) {
    setState(() => _isPressed = true);
    _pressAnim.forward();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _pressAnim.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressAnim.reverse();
  }

  @override
  void dispose() {
    _anim.dispose();
    _pressAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double usableTrackWidth = _trackWidth - _padding * 2 - _thumbW;

    return GestureDetector(
      onTap: _toggle,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: SizedBox(
        width: _trackWidth,
        height: _trackHeight,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // full grey background track
            Positioned.fill(
              child: Center(
                child: Container(
                  width: _trackWidth,
                  height: _trackHeight * 0.52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E9EA), // light grey track
                    borderRadius: BorderRadius.circular(_trackHeight),
                  ),
                ),
              ),
            ),

            AnimatedBuilder(
              animation: _anim,
              builder: (_, __) {

                final double thumbLeft = _padding + usableTrackWidth * _anim.value;

                final double activeWidth = thumbLeft + (_thumbW / 2);
                return Positioned(
                  left: _padding,
                  top: (_trackHeight - (_trackHeight * 0.52)) / 2,
                  bottom: (_trackHeight - (_trackHeight * 0.52)) / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_trackHeight),
                    child: SizedBox(
                      width: activeWidth.clamp(0.0, _trackWidth),
                      height: _trackHeight * 0.52,
                      child: Container(color: defaultAccentColor_(context)), // blue
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_anim, _pressAnim]),
              builder: (_, __) {
                final double thumbLeft = _padding + usableTrackWidth * _anim.value;

                // press factor 0..1 (0 = no press, 1 = fully pressed)
                final double press = _pressAnim.value;
                // squish scale: compress height by up to 12% and widen slightly
                final double scaleY = 1.0 - (0.12 * press);
                final double scaleX = 1.0 + (0.06 * press);

                // glow opacity depends on either on-state or press
                final double glowBase = (_anim.value * 0.9) + (press * 0.6);
                final double glowOpacity = (glowBase * 0.45).clamp(0.0, 0.6);

                return Positioned(
                  left: thumbLeft,
                  child: SizedBox(
                    width: _thumbW,
                    height: _thumbH,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // subtle glow behind thumb (blue)
                        Opacity(
                          opacity: glowOpacity,
                          child: Container(
                            width: _thumbW * 1.12,
                            height: _thumbH * 1.12,
                            decoration: BoxDecoration(
                              color: widget.activeColor,
                              borderRadius: BorderRadius.circular(_thumbH),
                              boxShadow: [
                                BoxShadow(
                                  color: defaultAccentColor_(context).withOpacity(glowOpacity),
                                  blurRadius: 18 * (0.6 + glowOpacity),
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                          ),
                        ),

                        Transform.scale(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          child: Container(
                            width: _thumbW,
                            height: _thumbH,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.98),
                              borderRadius: BorderRadius.circular(_thumbH / 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18 * (1.0 - 0.6 * press)),
                                  blurRadius: 18.0,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.85),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [

                                Positioned(
                                  left: 8,
                                  top: 6,
                                  right: 8,
                                  child: Container(
                                    height: _thumbH * 0.18,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.9),
                                          Colors.white.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 6,
                                  child: Container(
                                    height: _thumbH * 0.12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.02),
                                          Colors.black.withOpacity(0.06),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}