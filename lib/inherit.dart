import 'package:flutter/widgets.dart';
import 'package:vacy/services.dart';

class CalendarClientInherited extends InheritedWidget {
  final CalendarClient calendarClient = CalendarClient();

  CalendarClientInherited({Widget child}) : super(child: child) {}
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static CalendarClientInherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CalendarClientInherited>();
}
