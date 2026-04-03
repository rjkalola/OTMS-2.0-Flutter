import 'dart:ui';

import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class FavoritePopupManager {
  static OverlayEntry? _overlayEntry;

  static void show({
    required BuildContext context,
    required LayerLink layerLink,
    required List<ProjectInfo> projects,
    required Function(ProjectInfo) onProjectSelected,
  }) {
    hide(); // Ensure any existing popup is removed

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 1. ADDED: The Background Blur Layer
          // Positioned.fill ensures it covers the entire screen
          Positioned.fill(
            child: GestureDetector(
              onTap: hide, // Tap outside to dismiss
              // AbsorbPointer prevents interactions with the blurred background
              behavior: HitTestBehavior.opaque,
              child: ClipRect( // Required to keep the blur contained
                child: BackdropFilter(
                  // Use a modest blur value to enhance the "Liquid Glass" look
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: Container(
                    // Slightly darkened overlay to increase popup contrast
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
            ),
          ),

          // 2. The Popup Content (Unchanged positioning)
          Positioned(
            width: 220,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              followerAnchor: Alignment.topCenter,
              targetAnchor: Alignment.bottomCenter,
              offset: const Offset(0, 10),
              child: Material(
                color: Colors.transparent,
                child: _FavoritePopupContent(
                  projects: projects,
                  onSelected: (project) {
                    onProjectSelected(project);
                    hide();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _FavoritePopupContent extends StatelessWidget {
  final List<ProjectInfo> projects; // Updated type
  final Function(ProjectInfo) onSelected;

  const _FavoritePopupContent({required this.projects, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(20, 10),
          painter: TrianglePainter(),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Map through the ProjectInfo list
                children: projects.map((project) => _buildItem(project)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(ProjectInfo project) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onSelected(project),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.bookmark, color: Colors.deepOrangeAccent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  project.name ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;
    var path = Path();

    // Path for an upward pointing triangle
    path.moveTo(size.width / 2, 0);          // Top tip
    path.lineTo(size.width, size.height);    // Bottom right
    path.lineTo(0, size.height);             // Bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}