import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Horizontal thumbnail strip with scroll arrow and progress indicator (create announcement).
class AnnouncementAttachmentStrip extends StatefulWidget {
  const AnnouncementAttachmentStrip({
    super.key,
    required this.filesList,
    required this.onGridItemClick,
  });

  final RxList<FilesInfo> filesList;
  final Function(int index, String action) onGridItemClick;

  @override
  State<AnnouncementAttachmentStrip> createState() =>
      _AnnouncementAttachmentStripState();
}

class _AnnouncementAttachmentStripState extends State<AnnouncementAttachmentStrip> {
  final PageController _pageController =
      PageController(viewportFraction: _viewportFraction);
  double _currentPage = 0;

  static const double _viewportFraction = 0.34;
  static const double _tileGap = 8;
  static const double _thumbHeight = 100;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_pageController.hasClients) return;
    setState(() {
      _currentPage = _pageController.page ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnnouncementAttachmentStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final visibleCount = _visibleFileIndexes().length;
    final maxIndex = visibleCount == 0 ? 0 : visibleCount - 1;
    if (_currentPage > maxIndex && _pageController.hasClients) {
      _pageController.jumpToPage(maxIndex);
    }
  }

  List<int> _visibleFileIndexes() {
    final indexes = <int>[];
    for (int i = 0; i < widget.filesList.length; i++) {
      final path = widget.filesList[i].imageUrl ?? "";
      if (path.isNotEmpty) {
        indexes.add(i);
      }
    }
    return indexes;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final visibleIndexes = _visibleFileIndexes();
        if (visibleIndexes.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _thumbHeight,
                child: PageView.builder(
                  controller: _pageController,
                  padEnds: false,
                  itemCount: visibleIndexes.length,
                  itemBuilder: (context, pageIndex) {
                    final sourceIndex = visibleIndexes[pageIndex];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: pageIndex == visibleIndexes.length - 1 ? 0 : _tileGap,
                      ),
                      child: InkWell(
                        onTap: () => widget.onGridItemClick(
                          sourceIndex,
                          AppConstants.action.viewPhoto,
                        ),
                        child: DocumentView(
                          isEditable: true,
                          width: double.infinity,
                          height: _thumbHeight,
                          file: widget.filesList[sourceIndex].imageUrl ?? "",
                          onRemoveClick: () => widget.onGridItemClick(
                            sourceIndex,
                            AppConstants.action.removePhoto,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              _LinePagerIndicator(
                itemCount: visibleIndexes.length,
                firstVisibleIndex: _currentPage.floor(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinePagerIndicator extends StatelessWidget {
  const _LinePagerIndicator({
    required this.itemCount,
    required this.firstVisibleIndex,
  });

  final int itemCount;
  final int firstVisibleIndex;

  @override
  Widget build(BuildContext context) {
    // Requirement:
    // 3 files -> hide indicator
    // 4 files -> 2 lines
    // 5 files -> 3 lines
    if (itemCount <= 3) return const SizedBox.shrink();

    final lineCount = itemCount - 2;
    final safeFirstVisible = firstVisibleIndex.clamp(0, lineCount - 1);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor =
        isDark ? Colors.grey.shade700 : Colors.black.withValues(alpha: 0.14);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(lineCount, (index) {
        final isActive = index == safeFirstVisible;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 10,
          height: 3,
          decoration: BoxDecoration(
            color: isActive ? defaultAccentColor_(context) : inactiveColor,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
