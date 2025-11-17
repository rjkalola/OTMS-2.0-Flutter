import 'package:flutter/material.dart';

/// ---------- PreciseSlider with subtle liquid-glass effects ----------
class PreciseSlider extends StatefulWidget {
  final double value; // 0..100
  final ValueChanged<double> onChanged;
  const PreciseSlider({super.key, required this.value, required this.onChanged});

  @override
  State<PreciseSlider> createState() => _PreciseSliderState();
}

class _PreciseSliderState extends State<PreciseSlider> {
  static const double _thumbW = 60; // large pill thumb width (white)
  static const double _thumbH = 35;  // thumb height
  static const double _trackHeight = 10;

  double _localValue = 0;
  bool _dragging = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value.clamp(0, 100);
  }

  @override
  void didUpdateWidget(covariant PreciseSlider old) {
    super.didUpdateWidget(old);
    _localValue = widget.value.clamp(0, 100);
  }

  void _updateFromDx(Offset localPosition, double trackWidth) {
    final double leftBound = _thumbW / 2;
    final double rightBound = trackWidth - _thumbW / 2;
    final double x = (localPosition.dx).clamp(leftBound, rightBound);
    final double t = (x - leftBound) / (rightBound - leftBound);
    final double val = (t * 100).clamp(0, 100);
    setState(() {
      _localValue = val;
    });
    widget.onChanged(val);
  }

  void _onPanStart(DragDownDetails details, double width) {
    setState(() {
      _dragging = true;
      _pressed = true;
    });
    _updateFromDx(details.localPosition, width);
  }

  void _onPanUpdate(DragUpdateDetails details, double width) {
    _updateFromDx(details.localPosition, width);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _dragging = false;
      _pressed = false;
    });
  }
  void _onPanCancel() {
    setState(() {
      _dragging = false;
      _pressed = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double totalWidth = constraints.maxWidth;
      final double leftBound = _thumbW / 2;
      final double rightBound = totalWidth - _thumbW / 2;
      final double t = (_localValue / 100).clamp(0.0, 1.0);
      final double thumbCenterX = leftBound + (rightBound - leftBound) * t;
      final double activeWidth = thumbCenterX; // active is up to thumb center

      // glow intensity when dragging or active (non-zero)
      final double glowBase = ( (_localValue > 0 ? 0.6 : 0.0) + (_dragging ? 0.9 : 0.0) );
      final double glowOpacity = (glowBase * 0.45).clamp(0.0, 0.7);

      // press scale factor
      final double press = _pressed ? 1.0 : 0.0;
      final double scaleY = 1.0 - (0.10 * press);
      final double scaleX = 1.0 + (0.05 * press);

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanDown: (d) => _onPanStart(d, totalWidth),
        onPanUpdate: (d) => _onPanUpdate(d, totalWidth),
        onPanEnd: _onPanEnd,
        onPanCancel: _onPanCancel,
        child: SizedBox(
          height: _thumbH + 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Full grey track (centered vertically)
              Positioned(
                left: leftBound,
                right: totalWidth - rightBound,
                top: (_thumbH + 20 - _trackHeight) / 2,
                child: Container(
                  height: _trackHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7E7E8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),

              // Active blue portion up to thumb center
              Positioned(
                left: leftBound,
                top: (_thumbH + 20 - _trackHeight) / 2,
                width: (activeWidth - leftBound).clamp(0.0, totalWidth),
                child: Container(
                  height: _trackHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E9BFF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),

              Positioned(
                left: thumbCenterX - (_thumbW * 0.56),
                top: 10 - (_thumbH * 0.08),
                child: Opacity(
                  opacity: glowOpacity,
                  child: Container(
                    width: _thumbW * 1.2,
                    height: _thumbH * 1.1,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E9BFF).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(_thumbH),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E9BFF).withOpacity(glowOpacity),
                          blurRadius: 26 * (0.6 + glowOpacity),
                          spreadRadius: 1.5,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: thumbCenterX - (_thumbW / 2),
                top: 10,
                child: Transform.scale(
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
                          color: Colors.black.withOpacity(0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                        // subtle inner shadow to give glass depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.035),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.98),
                          Colors.white.withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // top-left glossy highlight
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
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.65),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // faint bottom shadow inside thumb
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
              ),
            ],
          ),
        ),
      );
    });
  }
}