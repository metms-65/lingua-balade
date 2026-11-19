import 'package:flutter/material.dart';

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D6B), brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    cardTheme: const CardThemeData(margin: EdgeInsets.zero),
  );
}

/// Code couleur des genres, commun aux tableaux et au vocabulaire.
Color genderColor(String? gender, Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return switch (gender) {
    'm' => dark ? const Color(0xFF82B1FF) : const Color(0xFF1E5FBF),
    'f' => dark ? const Color(0xFFFF8A80) : const Color(0xFFC62828),
    'n' => dark ? const Color(0xFF8CD98C) : const Color(0xFF2E7D32),
    'pl' => dark ? const Color(0xFFFFCC80) : const Color(0xFFD9730D),
    _ => dark ? Colors.white70 : Colors.black87,
  };
}

const genderLabels = {'m': 'masculin', 'f': 'féminin', 'n': 'neutre', 'pl': 'pluriel'};
