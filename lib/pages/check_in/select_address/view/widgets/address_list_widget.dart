import 'package:flutter/material.dart';

class AddressListWidget extends StatelessWidget {
  const AddressListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(), //
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: List.generate(
          15,
          (position) => InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
              child: Row(
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
