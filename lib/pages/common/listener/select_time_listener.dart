import 'package:flutter/material.dart';

abstract class SelectTimeListener {
  void onSelectTime(TimeOfDay time, String dialogIdentifier);
}
