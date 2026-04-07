// lib/constants.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── API ───────────────────────────────────────────────────────────────────
// This is updated to point to your live d2r2 database backend
const String kWorkerBaseUrl = 'https://thragg-bank-api.your-subdomain.workers.dev';

// ─── Colors ────────────────────────────────────────────────────────────────
const Color kYellow       = Color(0xFFF5C800);
const Color kYellowLight  = Color(0xFFFFF176);
const Color kYellowDark   = Color(0xFFD4AA00);
const Color kWhite        = Color(0xFFFFFFFF);
const Color kOffWhite     = Color(0xFFFFFDE7);
const Color kCream        = Color(0xFFFFF8E1);
const Color kDark         = Color(0xFF1A1A1A);
const Color kDarkMid      = Color(0xFF2D2D2D);
const Color kGrey         = Color(0xFF757575);
const Color kGreyLight    = Color(0xFFF5F5F5);
const Color kSuccess      = Color(0xFF00C853);
const Color kDanger       = Color(0xFFFF3D00);

// ─── Theme ─────────────────────────────────────────────────────────────────
ThemeData thraggTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:   kYellow,
      secondary: kYellowDark,
      surface:   kWhite,
      onPrimary: kDark,
      onSurface: kDark,
    ),
    scaffoldBackgroundColor: kWhite,
    textTheme: GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 36, fontWeight: FontWeight.w800, color: kDark,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 28, fontWeight: FontWeight.w700, color: kDark,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22, fontWeight: FontWeight.w700, color: kDark,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18, fontWeight: FontWeight.w600, color: kDark,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16, fontWeight: FontWeight.w400, color: kDark,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14, fontWeight: FontWeight.w400, color: kGrey,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kYellow,
        foregroundColor: kDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        textStyle: GoogleFonts.dmSans(
          fontSize: 16, fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kGreyLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: kYellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: kDanger, width: 1.5),
      ),
    ),
  );
}
