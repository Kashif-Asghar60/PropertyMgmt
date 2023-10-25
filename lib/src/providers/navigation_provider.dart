import 'package:flutter/material.dart';

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0; // Default to the first button

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
