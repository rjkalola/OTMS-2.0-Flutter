import 'package:flutter/material.dart';
class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black12,
          width: double.infinity,
          height: 300,
        ),
         Container(
          margin: EdgeInsets.all(10),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Color(0x40000000),
            shape: BoxShape.circle,
          ),
          child: Icon(
            size: 24,
            Icons.arrow_back,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
