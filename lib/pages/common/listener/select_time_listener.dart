import 'package:flutter/material.dart';

abstract class SelectTimeListener {
  void onSelectTime(DateTime time, String dialogIdentifier);
}
