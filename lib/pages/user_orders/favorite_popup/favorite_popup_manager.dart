import 'dart:ui';
import 'package:belcka/pages/user_orders/project_service/project_folder_response.dart';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
// Ensure this path matches your project structure
import 'package:belcka/pages/user_orders/project_service/project_folder_response.dart';

class FavoritePopupManager {
  static OverlayEntry? _overlayEntry;

  static void show({
    required BuildContext context,
    required LayerLink layerLink,
    required List<ProjectFolderInfo> folders,
    required Function(ProjectFolderInfo) onProjectSelected,
  }) {
    hide();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    bool showAbove = position.dy > (screenSize.height * 0.6);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hide,
              behavior: HitTestBehavior.opaque,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
            ),
          ),

          // Popup Content
          Positioned(
            width: 220,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              followerAnchor: showAbove ? Alignment.bottomCenter : Alignment.topCenter,
              targetAnchor: showAbove ? Alignment.topCenter : Alignment.bottomCenter,
              offset: Offset(0, showAbove ? -10 : 10),
              child: Material(
                color: Colors.transparent,
                child: _FavoritePopupContent(
                  folders: folders,
                  showAbove: showAbove,
                  onSelected: (selectedFolder) {
                    onProjectSelected(selectedFolder);
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
  final List<ProjectFolderInfo> folders;
  final Function(ProjectFolderInfo) onSelected;
  final bool showAbove;

  const _FavoritePopupContent({
    required this.folders,
    required this.onSelected,
    required this.showAbove,
  });

  @override
  Widget build(BuildContext context) {
    final triangle = CustomPaint(
      size: const Size(20, 10),
      painter: TrianglePainter(isDown: showAbove),
    );

    final contentBox = Container(
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
            children: folders.map((project) => _buildItem(project)).toList(),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!showAbove) triangle, // Show triangle on top if popup is below icon
        contentBox,
        if (showAbove) triangle, // Show triangle on bottom if popup is above icon
      ],
    );
  }

  Widget _buildItem(ProjectFolderInfo folder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onSelected(folder),
        borderRadius: BorderRadius.circular(15),
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
              Icon(Icons.bookmark, color: folder.folderColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  folder.name ?? "",
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
  final bool isDown;

  TrianglePainter({required this.isDown});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;
    var path = Path();

    if (isDown) {
      // Triangle pointing down (arrow at bottom of popup)
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    } else {
      // Triangle pointing up (arrow at top of popup)
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}