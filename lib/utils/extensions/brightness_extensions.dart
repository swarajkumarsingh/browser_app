import 'package:flutter/material.dart';

extension BrightnessExtensions on Brightness {
  bool get isDarkModeEnabled => this == Brightness.dark;

  Brightness get inverse {
    return switch (this) {
      Brightness.dark => Brightness.light,
      Brightness.light => Brightness.dark,
    };
  }
}
