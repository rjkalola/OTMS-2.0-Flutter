import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';

void main() {
  runApp(MaterialApp(home: CreateNewTeamScreen()));
}

class CreateNewTeamScreen extends StatefulWidget {
  @override
  _CreateNewTeamScreenState createState() => _CreateNewTeamScreenState();
}

class _CreateNewTeamScreenState extends State<CreateNewTeamScreen> {
  final _teamNameController = TextEditingController(text: "Alex");
  final _supervisorController = TextEditingController(text: "Alex Tomson");

  final List<Map<String, String>> members = [
    {"name": "Ramil Veliiiev", "role": "Handyman"},
    {"name": "Raman Sharma", "role": "Carpenter"},
    {"name": "Harvi", "role": "Painter"},
    {"name": "Iurii T", "role": "Labourer"},
    {"name": "Iurii T", "role": "Labourer"},
    {"name": "Iurii T", "role": "Labourer"},
    {"name": "Iurii T", "role": "Labourer"},
    {"name": "Iurii T", "role": "Labourer"},
    {"name": "Iurii T", "role": "Labourer"},
    {"name": "Iurii T", "role": "Labourer"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'create_new_team'.tr,
          isCenterTitle: false,
          isBack: true,
          widgets: actionButtons()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEditableField('team_name'.tr, _teamNameController),
            const SizedBox(height: 10),
            buildEditableField('select_supervisor'.tr, _supervisorController),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.centerLeft,
              child: Text('add_team_members'.tr),
            ),
            const SizedBox(height: 16),
            ...members.map((member) => buildMemberCard(member)).toList(),
            const SizedBox(height: 100), // For bottom space
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 16),
        ),
        Divider(color: Colors.grey.shade400),
      ],
    );
  }

  Widget buildMemberCard(Map<String, String> member) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/user.png"),
          // Replace with actual image
          radius: 24,
        ),
        title: Text(member["name"] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(member["role"] ?? ""),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              members.remove(member);
            });
          },
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      TextButton(
        onPressed: () {
          // Handle save logic
        },
        child: Text('save'.tr,
            style: TextStyle(color: defaultAccentColor_(context), fontSize: 16)),
      )
    ];
  }
}
