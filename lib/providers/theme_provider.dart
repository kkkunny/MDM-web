import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeProvider extends ChangeNotifier {
  bool get isDarkMode => !Get.isDarkMode;

  void toggleTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    notifyListeners();
  }
}
