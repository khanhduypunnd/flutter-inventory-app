import 'package:flutter/material.dart';

class StaffDataWrapper extends InheritedWidget {
  final Map<String, dynamic>? staffData;

  const StaffDataWrapper({
    Key? key,
    required Widget child,
    required this.staffData,
  }) : super(key: key, child: child);

  static StaffDataWrapper? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StaffDataWrapper>();
  }

  @override
  bool updateShouldNotify(StaffDataWrapper oldWidget) =>
      staffData != oldWidget.staffData;
}
