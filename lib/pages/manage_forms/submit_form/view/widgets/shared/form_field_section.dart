import 'package:flutter/material.dart';

class FormFieldSection extends StatelessWidget {
  const FormFieldSection({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: child,
    );
  }
}
