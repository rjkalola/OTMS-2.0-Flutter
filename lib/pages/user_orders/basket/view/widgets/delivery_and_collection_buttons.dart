import 'package:flutter/material.dart';

class DeliveryAndCollectionButtons extends StatelessWidget{

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DeliveryAndCollectionButtons({required this.title,
    required this.isSelected,
    required this.onTap});

  Widget build (BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3578F6) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: isSelected
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
