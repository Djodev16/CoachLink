import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'EN';

  String get selectedLanguage => _selectedLanguage;

  
  void updateLanguage(String newLang) {
    _selectedLanguage = newLang; 
    notifyListeners(); 
  }

  
  void toggleLanguage() {
    if (_selectedLanguage == 'EN') {
      _selectedLanguage = 'AR';
    } else if (_selectedLanguage == 'AR') {
      _selectedLanguage = 'FR';
    } else {
      _selectedLanguage = 'EN';
    }
    notifyListeners();
  }
}