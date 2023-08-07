import 'package:flutter/material.dart';

import 'colors.dart';

class LightColorScheme extends ColorScheme {
  LightColorScheme()
      : super(
          primary: LightColors.primary,
          onPrimary: LightColors.onPrimary,
          primaryContainer: LightColors.primaryContainer,
          onPrimaryContainer: LightColors.onPrimaryContainer,
          secondary: LightColors.secondary,
          onSecondary: LightColors.onSecondary,
          secondaryContainer: LightColors.secondaryContainer,
          onSecondaryContainer: LightColors.onSecondaryContainer,
          tertiary: LightColors.tertiary,
          onTertiary: LightColors.onTertiary,
          tertiaryContainer: LightColors.tertiaryContainer,
          onTertiaryContainer: LightColors.onTertiaryContainer,
          error: LightColors.error,
          onError: LightColors.onError,
          errorContainer: LightColors.errorContainer,
          onErrorContainer: LightColors.onErrorContainer,
          background: LightColors.background,
          onBackground: LightColors.onBackground,
          surface: LightColors.surface,
          onSurface: LightColors.onSurface,
          outline: LightColors.outline,
          surfaceVariant: LightColors.surfaceVariant,
          onSurfaceVariant: LightColors.onSurfaceVariant,
          brightness: Brightness.light,
        );
}

class DarkColorScheme extends ColorScheme {
  DarkColorScheme()
      : super(
          primary: DarkColors.primary,
          onPrimary: DarkColors.onPrimary,
          primaryContainer: DarkColors.primaryContainer,
          onPrimaryContainer: DarkColors.onPrimaryContainer,
          secondary: DarkColors.secondary,
          onSecondary: DarkColors.onSecondary,
          secondaryContainer: DarkColors.secondaryContainer,
          onSecondaryContainer: DarkColors.onSecondaryContainer,
          tertiary: DarkColors.tertiary,
          onTertiary: DarkColors.onTertiary,
          tertiaryContainer: DarkColors.tertiaryContainer,
          onTertiaryContainer: DarkColors.onTertiaryContainer,
          error: DarkColors.error,
          onError: DarkColors.onError,
          errorContainer: DarkColors.errorContainer,
          onErrorContainer: DarkColors.onErrorContainer,
          background: DarkColors.background,
          onBackground: DarkColors.onBackground,
          surface: DarkColors.surface,
          onSurface: DarkColors.onSurface,
          outline: DarkColors.outline,
          surfaceVariant: DarkColors.surfaceVariant,
          onSurfaceVariant: DarkColors.onSurfaceVariant,
          brightness: Brightness.dark,
        );
}
