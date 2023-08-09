import 'package:flutter/material.dart';

import 'scheme.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData.from(
      useMaterial3: true,
      colorScheme: LightColorScheme(),
    );
  }

  static ThemeData get dark {
    return ThemeData.from(
      useMaterial3: true,
      colorScheme: DarkColorScheme(),
    );
  }
}
