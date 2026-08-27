import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final spotlightTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0F1115),
  cardColor: const Color(0xFF1A1D24),
  primaryColor: const Color(0xFF00F2FE),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00F2FE),
    secondary: Color(0xFFFF9F43),
    surface: Color(0xFF1A1D24),
  ),
  textTheme: TextTheme(
    headlineMedium: GoogleFonts.jetBrainsMono(
      color: const Color(0xFFF8F9FA),
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.inter(color: const Color(0xFFF8F9FA), fontSize: 14),
    labelSmall: GoogleFonts.jetBrainsMono(color: const Color(0xFF8A92A6)),
  ),
);
