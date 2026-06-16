import 'package:flutter/material.dart';

class Project {
  final String id;
  final String name;
  final Color iconBgColor;
  final IconData icon;

  const Project({
    required this.id,
    required this.name,
    required this.iconBgColor,
    required this.icon,
  });
}

class Shift {
  final String id;
  final String name;
  final Color iconBgColor;
  final IconData icon;

  const Shift({
    required this.id,
    required this.name,
    required this.iconBgColor,
    required this.icon,
  });
}

// Test Data

final List<Project> testProjects = [
  Project(
    id: '1',
    name: 'Hackney OT',
    iconBgColor: const Color(0xFFE8F0FE),
    icon: Icons.apartment,
  ),
  Project(
    id: '2',
    name: 'Haringey Disrepairs',
    iconBgColor: const Color(0xFFFFF3E0),
    icon: Icons.domain,
  ),
  Project(
    id: '3',
    name: 'Haringey Voids',
    iconBgColor: const Color(0xFFF3E5F5),
    icon: Icons.business,
  ),
  Project(
    id: '4',
    name: 'Camden Voids',
    iconBgColor: const Color(0xFFFCE4EC),
    icon: Icons.location_city,
  ),
  Project(
    id: '5',
    name: 'Islington Works',
    iconBgColor: const Color(0xFFE8F5E9),
    icon: Icons.corporate_fare,
  ),
  Project(
    id: '6',
    name: 'Tower Hamlets',
    iconBgColor: const Color(0xFFE3F2FD),
    icon: Icons.foundation,
  ),
];

final List<Shift> testShifts = [
  Shift(
    id: '1',
    name: 'Daywork',
    iconBgColor: const Color(0xFFFFF9E6),
    icon: Icons.wb_sunny_outlined,
  ),
  Shift(
    id: '2',
    name: 'Price Work',
    iconBgColor: const Color(0xFFE8F4FD),
    icon: Icons.monetization_on_outlined,
  ),
  Shift(
    id: '3',
    name: 'Weekend',
    iconBgColor: const Color(0xFFF0EEFF),
    icon: Icons.weekend_outlined,
  ),
];

//Icon Colors per project

Color _projectIconColor(Color bg) {
  if (bg == const Color(0xFFE8F0FE)) return const Color(0xFF3D6CF5);
  if (bg == const Color(0xFFFFF3E0)) return const Color(0xFFFF8C00);
  if (bg == const Color(0xFFF3E5F5)) return const Color(0xFF8E44AD);
  if (bg == const Color(0xFFFCE4EC)) return const Color(0xFFE91E63);
  if (bg == const Color(0xFFE8F5E9)) return const Color(0xFF2E7D32);
  return const Color(0xFF1565C0);
}

Color _shiftIconColor(Color bg) {
  if (bg == const Color(0xFFFFF9E6)) return const Color(0xFFF59E0B);
  if (bg == const Color(0xFFE8F4FD)) return const Color(0xFF2196F3);
  if (bg == const Color(0xFFF0EEFF)) return const Color(0xFF7C3AED);
  return const Color(0xFF555555);
}

// Shared Bottom Sheet Header

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
          color: const Color(0xFFDDDEE6),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// Project Icon Widget

class _ProjectIcon extends StatelessWidget {
  final Project project;
  final double size;

  const _ProjectIcon({required this.project, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: project.iconBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        project.icon,
        color: _projectIconColor(project.iconBgColor),
        size: size * 0.55,
      ),
    );
  }
}

// Shift Icon Widget

class _ShiftIcon extends StatelessWidget {
  final Shift shift;

  const _ShiftIcon({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: shift.iconBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        shift.icon,
        color: _shiftIconColor(shift.iconBgColor),
        size: 24,
      ),
    );
  }
}

// Project Selection Bottom Sheet

class ProjectSelectionSheet extends StatefulWidget {
  final void Function(Project project) onProjectSelected;
  final VoidCallback onCancel;

  const ProjectSelectionSheet({
    super.key,
    required this.onProjectSelected,
    required this.onCancel,
  });

  @override
  State<ProjectSelectionSheet> createState() => _ProjectSelectionSheetState();
}

class _ProjectSelectionSheetState extends State<ProjectSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Project> _filteredProjects = testProjects;

  @override
  void initState() {
    super.initState();
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
      _filteredProjects = testProjects
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Project',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search projects...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () => _searchController.clear(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.close,
                            color: Colors.grey.shade400, size: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Project list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.38,
            ),
            child: _filteredProjects.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No projects found',
                        style:
                            TextStyle(color: Color(0xFF888AA0), fontSize: 14),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredProjects.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Color(0xFFF0F1F5),
                    ),
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return _ProjectListTile(
                        project: project,
                        onTap: () => widget.onProjectSelected(project),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 12),

          // Cancel button
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: _RedButton(
              label: 'Cancel',
              onTap: widget.onCancel,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectListTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _ProjectListTile({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _ProjectIcon(project: project),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                project.name,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1D2E),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}

//  Shift Selection Bottom Sheet

class ShiftSelectionSheet extends StatelessWidget {
  final Project selectedProject;
  final void Function(Shift shift) onShiftSelected;
  final VoidCallback onBack;

  const ShiftSelectionSheet({
    super.key,
    required this.selectedProject,
    required this.onShiftSelected,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),

          // Selected project banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _ProjectIcon(project: selectedProject, size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Project selected',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF888AA0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        selectedProject.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1D2E),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onBack,
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D6CF5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Select Shift title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Shift',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Shift list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: testShifts.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFF0F1F5)),
            itemBuilder: (context, index) {
              final shift = testShifts[index];
              return _ShiftListTile(
                shift: shift,
                onTap: () => onShiftSelected(shift),
              );
            },
          ),

          const SizedBox(height: 12),

          // Back button
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: _RedButton(
              label: 'Back',
              onTap: onBack,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftListTile extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;

  const _ShiftListTile({required this.shift, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _ShiftIcon(shift: shift),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                shift.name,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1D2E),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}

// Shared Red Button

class _RedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RedButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF4444)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4444).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Selection Flow Controller

class ProjectShiftSelector {
  static void start({
    required BuildContext context,
    required void Function(Project project, Shift shift) onComplete,
  }) {
    _showProjectSheet(context: context, onComplete: onComplete);
  }

  static void _showProjectSheet({
    required BuildContext context,
    required void Function(Project project, Shift shift) onComplete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProjectSelectionSheet(
        onProjectSelected: (project) {
          Navigator.of(context).pop(); // close project sheet
          _showShiftSheet(
            context: context,
            project: project,
            onComplete: onComplete,
          );
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  static void _showShiftSheet({
    required BuildContext context,
    required Project project,
    required void Function(Project project, Shift shift) onComplete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShiftSelectionSheet(
        selectedProject: project,
        onShiftSelected: (shift) {
          Navigator.of(context).pop(); // close shift sheet
          onComplete(project, shift);
        },
        onBack: () {
          Navigator.of(context).pop(); // close shift sheet
          _showProjectSheet(context: context, onComplete: onComplete);
        },
      ),
    );
  }
}

class ProjectShiftDemoScreen extends StatefulWidget {
  const ProjectShiftDemoScreen({super.key});

  @override
  State<ProjectShiftDemoScreen> createState() => _ProjectShiftDemoScreenState();
}

class _ProjectShiftDemoScreenState extends State<ProjectShiftDemoScreen> {
  Project? _selectedProject;
  Shift? _selectedShift;

  void _startSelection() {
    ProjectShiftSelector.start(
      context: context,
      onComplete: (project, shift) {
        setState(() {
          _selectedProject = project;
          _selectedShift = shift;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A6CF7), Color(0xFF3A5CE5)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 24),
                  ),
                ),
                const Center(
                  child: Text(
                    '00:00:00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Result display
          Expanded(
            child: _selectedProject == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_outlined,
                          size: 56, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Tap "Start Work" to select\na project and shift',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 56, color: Color(0xFF4CAF50)),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to clock in!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1D2E),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _InfoCard(
                          label: 'Project',
                          value: _selectedProject!.name,
                          icon: _selectedProject!.icon,
                          iconBg: _selectedProject!.iconBgColor,
                        ),
                        const SizedBox(height: 10),
                        _InfoCard(
                          label: 'Shift',
                          value: _selectedShift!.name,
                          icon: _selectedShift!.icon,
                          iconBg: _selectedShift!.iconBgColor,
                        ),
                        const SizedBox(height: 28),
                        GestureDetector(
                          onTap: _startSelection,
                          child: Text(
                            'Change selection',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Start Work button
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 12,
            ),
            child: GestureDetector(
              onTap: _startSelection,
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Start Work',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: _projectIconColor(iconBg)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888AA0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
