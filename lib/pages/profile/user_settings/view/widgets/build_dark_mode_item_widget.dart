import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class BuildDarkModeItemWidget extends StatelessWidget {
  BuildDarkModeItemWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Card(
      margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
      elevation: 2,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      color:backgroundColor,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(
                width: 1,
                color: Colors.grey.shade200)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: const Icon(Icons.dark_mode_outlined, color: Colors.black,size: 32,),
          title: const Text(
            'Dark mode',
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
          ),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }
}