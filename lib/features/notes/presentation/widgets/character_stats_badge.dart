import 'package:flutter/material.dart';

/// Unobtrusive pill badge showing character count, word count, and reading time (Phase 2).
class CharacterStatsBadge extends StatelessWidget {
  final int characterCount;
  final int wordCount;
  final String readingTime;

  const CharacterStatsBadge({
    super.key,
    required this.characterCount,
    required this.wordCount,
    required this.readingTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.text_fields_rounded,
            size: 14,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 6),
          Text(
            '$characterCount chars • $wordCount words • $readingTime',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
