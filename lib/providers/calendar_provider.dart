
import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void setSelectedDay(DateTime? day) {
    _selectedDay = day;
    notifyListeners();
  }
}