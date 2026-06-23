import 'package:flutter/material.dart';

class LocationIllustration extends StatelessWidget {
  const LocationIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110, height: 78,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 6,
            child: Container(
              width: 100, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFE3E9FB), borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Positioned(left: 4, bottom: 14, child: _TreeShape(color: const Color(0xFFC9D6F5))),
          Positioned(right: 6, bottom: 16, child: _TreeShape(color: const Color(0xFFD3DEF8), size: 0.8)),
          Positioned(top: 0, left: 6, child: _CloudShape()),
          Positioned(top: 8, right: 0, child: _CloudShape(size: 0.7)),
          Positioned(
            bottom: 28,
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF4A6CF7),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: const Color(0xFF4A6CF7).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.location_on, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
class _TreeShape extends StatelessWidget {
  final Color color;
  final double size;
  const _TreeShape({required this.color, this.size = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22 * size, height: 28 * size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10 * size)),
    );
  }
}

class _CloudShape extends StatelessWidget {
  final double size;
  const _CloudShape({this.size = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26 * size, height: 12 * size,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10 * size)),
    );
  }
}