import 'package:flutter/material.dart';

abstract class LightColors {
  static Color get primary => const Color(0xFF6750A4);
  static Color get onPrimary => const Color(0xFFFFFFFF);
  static Color get primaryContainer => const Color(0xFFEADDFF);
  static Color get onPrimaryContainer => const Color(0xFF21005D);

  static Color get secondary => const Color(0xFF625B71);
  static Color get onSecondary => const Color(0xFFFFFFFF);
  static Color get secondaryContainer => const Color(0xFFE8DEF8);
  static Color get onSecondaryContainer => const Color(0xFF1D192B);

  static Color get tertiary => const Color(0xFF7D5260);
  static Color get onTertiary => const Color(0xFFFFFFFF);
  static Color get tertiaryContainer => const Color(0xFFFFD8E4);
  static Color get onTertiaryContainer => const Color(0xFF31111D);

  static Color get error => const Color(0xFFB3261E);
  static Color get onError => const Color(0xFFFFFFFF);
  static Color get errorContainer => const Color(0xFFF9DEDC);
  static Color get onErrorContainer => const Color(0xFF410E0B);

  static Color get background => const Color(0xFFFFFBFE);
  static Color get onBackground => const Color(0xFF1C1B1F);
  static Color get surface => const Color(0xFFFFFBFE);
  static Color get onSurface => const Color(0xFF1C1B1F);
  static Color get outline => const Color(0xFF79747E);
  static Color get surfaceVariant => const Color(0xFFE7E0EC);
  static Color get onSurfaceVariant => const Color(0xFF49454F);
}

abstract class DarkColors {
  static Color get primary => const Color(0xFFD0BCFF);
  static Color get onPrimary => const Color(0xFF381E72);
  static Color get primaryContainer => const Color(0xFF4F378B);
  static Color get onPrimaryContainer => const Color(0xFFEADDFF);

  static Color get secondary => const Color(0xFFCCC2DC);
  static Color get onSecondary => const Color(0xFF332D41);
  static Color get secondaryContainer => const Color(0xFF4A4458);
  static Color get onSecondaryContainer => const Color(0xFFE8DEF8);

  static Color get tertiary => const Color(0xFFEFB8C8);
  static Color get onTertiary => const Color(0xFF492532);
  static Color get tertiaryContainer => const Color(0xFF633B48);
  static Color get onTertiaryContainer => const Color(0xFFFFD8E4);

  static Color get error => const Color(0xFFF2B8B5);
  static Color get onError => const Color(0xFF601410);
  static Color get errorContainer => const Color(0xFF8C1D18);
  static Color get onErrorContainer => const Color(0xFFF9DEDC);

  static Color get background => const Color(0xFF1C1B1F);
  static Color get onBackground => const Color(0xFFE6E1E5);
  static Color get surface => const Color(0xFF1C1B1F);
  static Color get onSurface => const Color(0xFFE6E1E5);
  static Color get outline => const Color(0xFF938F99);
  static Color get surfaceVariant => const Color(0xFF49454F);
  static Color get onSurfaceVariant => const Color(0xFFCAC4D0);
}
