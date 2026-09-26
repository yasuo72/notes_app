/// Helper computing real-time statistics for Note content (Phase 2 requirement).
class TextStatsHelper {
  TextStatsHelper._();

  /// Total count of all characters including whitespaces.
  static int getCharacterCount(String text) {
    return text.length;
  }

  /// Total count of characters excluding whitespaces.
  static int getNonSpaceCharCount(String text) {
    return text.replaceAll(RegExp(r'\s'), '').length;
  }

  /// Word count calculated using whitespace delimiter.
  static int getWordCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  /// Estimated reading time in minutes (based on 200 words per minute average).
  static String getReadingTime(String text) {
    final words = getWordCount(text);
    if (words == 0) return '0 min read';
    final minutes = (words / 200).ceil();
    return '$minutes min read';
  }

  /// Formatted compact badge string (e.g., "142 chars • 28 words").
  static String formatSummary(String text) {
    final chars = getCharacterCount(text);
    final words = getWordCount(text);
    return '$chars chars • $words words';
  }
}
