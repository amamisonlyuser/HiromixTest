import 'package:flutter/material.dart';

class SelectedOptionsProvider with ChangeNotifier {
  List<Map<String, String>> _selectedOptions = [];

  List<Map<String, String>> get selectedOptions => _selectedOptions;

  void updateSelectedOptions(List<Map<String, String>> options) {
    _selectedOptions = options;
    notifyListeners();
  }
}