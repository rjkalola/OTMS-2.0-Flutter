import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/project/project_list/view/active_project_dialog.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AddFolderView extends StatefulWidget {
  final List<dynamic> folders; // Using dynamic or your ProjectFolderInfo type
  final Function(String name, int projectId) onAdded;
  final VoidCallback onCancel;

  const AddFolderView({
    super.key,
    required this.folders,
    required this.onAdded,
    required this.onCancel,
  });

  @override
  State<AddFolderView> createState() => _AddFolderViewState();
}

class _AddFolderViewState extends State<AddFolderView>{
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final projectService = Get.find<ProjectService>();

  // Track the selected project object
  dynamic selectedProject;

  @override
  void dispose() {
    _albumController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextView(text: "create_new_album".tr,
            fontWeight: FontWeight.bold, fontSize: 14
        ),

        const SizedBox(height: 16),

        // 1. PROJECT SELECTION FIELD
        TextField(
          controller: _projectController,
          readOnly: true, // Prevents typing
          onTap: () {
            // TODO: Open a BottomSheet or Dialog to pick a project from projectService.projectList
            _showProjectPicker(context);
          },
          decoration: InputDecoration(
            labelText: "select_project".tr,
            labelStyle: TextStyle(color: accentColor),
            suffixIcon: Icon(Icons.keyboard_arrow_down, color: accentColor),
            filled: true,
            fillColor: accentColor.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 2. ALBUM NAME FIELD
        TextField(
          controller: _albumController,
          autofocus: false, // Turned off so it doesn't jump past the project selection
          decoration: InputDecoration(
            labelText: "album_name".tr,
            labelStyle: TextStyle(color: accentColor),
            filled: true,
            fillColor: accentColor.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: accentColor, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ACTION BUTTONS
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: widget.onCancel,
              child: Text("cancel".tr, style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final albumName = _albumController.text.trim();
                if (albumName.isNotEmpty) {
                  widget.onAdded(albumName, selectedProject?.id ?? 0);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("add".tr, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }

  void _showProjectPicker(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Allows for rounded corners
      isScrollControlled: true, // Better for lists
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // Limits height to 60% of screen
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar for the bottom sheet
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "select_project".tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: projectService.projectsList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final project = projectService.projectsList[index];
                    bool isSelected = selectedProject?.id == project.id;

                    return ListTile(
                      onTap: () {
                        setState(() {
                          selectedProject = project;
                          _projectController.text = project.name ?? "";
                        });
                        Navigator.pop(context);
                      },
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? accentColor : Colors.grey,
                      ),
                      title: Text(
                        project.name ?? "",
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? accentColor : Colors.black87,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: isSelected ? accentColor.withOpacity(0.05) : Colors.transparent,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}