import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectProjectBottomDialog extends StatefulWidget {
  final List<ProjectInfo> projects;
  final ValueChanged<ProjectInfo> onProjectSelected;
  final VoidCallback? onCancel;

  const SelectProjectBottomDialog({
    super.key,
    required this.projects,
    required this.onProjectSelected,
    this.onCancel,
  });

  @override
  State<SelectProjectBottomDialog> createState() =>
      _SelectProjectBottomDialogState();
}

class _SelectProjectBottomDialogState extends State<SelectProjectBottomDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<ProjectInfo> _filteredProjects = [];

  @override
  void initState() {
    super.initState();
    _filteredProjects = List.from(widget.projects);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProjects = widget.projects
          .where((project) =>
              !StringHelper.isEmptyString(project.name) &&
              project.name!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'select_project'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryTextColor_(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SearchField(controller: _searchController),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.38,
            ),
            child: _filteredProjects.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'empty_data_message'.tr,
                        style: TextStyle(
                          color: secondaryTextColor_(context),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredProjects.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: dividerColor_(context),
                    ),
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return InkWell(
                        onTap: () => widget.onProjectSelected(project),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded( 
                                child: Text(
                                  project.name ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: primaryTextColor_(context),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: secondaryTextColor_(context),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.onCancel != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPad + 16),
              child: _RedActionButton(
                label: 'cancel'.tr,
                onTap: widget.onCancel!,
              ),
            ),
          ] else
            SizedBox(height: bottomPad + 16),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(top: 12, bottom: 20),
        decoration: BoxDecoration(
          color: dividerColor_(context),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: titleBgColor_(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: secondaryTextColor_(context), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'search_projects_hint'.tr,
                hintStyle: TextStyle(
                  color: secondaryTextColor_(context),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: 14,
                color: primaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RedActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RedActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFFF484B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.62),
              blurRadius: 10,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
