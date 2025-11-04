import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  Rx<ThemeMode> themeMode = Rx<ThemeMode>(ThemeMode.light); // Initialize with the default theme mode

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }
}
