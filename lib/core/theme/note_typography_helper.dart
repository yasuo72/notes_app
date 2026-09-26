import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Available typography families for note writing assistance.
enum NoteFontFamily {
  inter('Inter', 'Modern Sans', Icons.font_download_outlined),
  plusJakartaSans('Plus Jakarta Sans', 'Geometric', Icons.text_fields_rounded),
  playfairDisplay('Playfair Display', 'Serif Classic', Icons.menu_book_rounded),
  firaCode('Fira Code', 'Monospace Tech', Icons.code_rounded),
  caveat('Caveat', 'Handwritten', Icons.edit_note_rounded);

  final String familyName;
  final String label;
  final IconData icon;

  const NoteFontFamily(this.familyName, this.label, this.icon);

  /// Generates a [TextStyle] for content input and viewing.
  TextStyle getTextStyle({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.normal,
    double height = 1.6,
  }) {
    switch (this) {
      case NoteFontFamily.inter:
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case NoteFontFamily.plusJakartaSans:
        return GoogleFonts.plusJakartaSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case NoteFontFamily.playfairDisplay:
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case NoteFontFamily.firaCode:
        return GoogleFonts.firaCode(
          fontSize: fontSize > 14 ? fontSize - 1.5 : fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case NoteFontFamily.caveat:
        return GoogleFonts.caveat(
          fontSize: fontSize + 4,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1.4,
        );
    }
  }

  /// Parses string into [NoteFontFamily] safely.
  static NoteFontFamily fromString(String? name) {
    if (name == null) return NoteFontFamily.inter;
    for (final font in NoteFontFamily.values) {
      if (font.familyName.toLowerCase() == name.toLowerCase() ||
          font.name.toLowerCase() == name.toLowerCase()) {
        return font;
      }
    }
    return NoteFontFamily.inter;
  }
}
