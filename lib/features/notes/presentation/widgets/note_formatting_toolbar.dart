import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/note_color_palette.dart';
import '../../../../core/theme/note_typography_helper.dart';
import '../controllers/note_editor_controller.dart';

enum _ToolbarSubMenu { none, colors, fonts }

/// Modern, floating writing assistance toolbar providing Markdown actions, color tints, and typography selectors.
class NoteFormattingToolbar extends StatefulWidget {
  final NoteEditorController controller;

  const NoteFormattingToolbar({super.key, required this.controller});

  @override
  State<NoteFormattingToolbar> createState() => _NoteFormattingToolbarState();
}

class _NoteFormattingToolbarState extends State<NoteFormattingToolbar> {
  _ToolbarSubMenu _activeSubMenu = _ToolbarSubMenu.none;

  void _toggleSubMenu(_ToolbarSubMenu menu) {
    setState(() {
      _activeSubMenu = _activeSubMenu == menu ? _ToolbarSubMenu.none : menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = widget.controller.selectedCategory.value.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sub-Panel (Colors or Fonts) when expanded
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildSubMenuPanel(context, isDark, primaryColor),
              crossFadeState: _activeSubMenu == _ToolbarSubMenu.none
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 220),
            ),

            // Primary Horizontal Toolbar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  // Color Palette Trigger
                  _buildSubMenuTrigger(
                    icon: Icons.palette_outlined,
                    label: 'Color',
                    isActive: _activeSubMenu == _ToolbarSubMenu.colors,
                    activeColor: const Color(0xFFF59E0B),
                    onTap: () => _toggleSubMenu(_ToolbarSubMenu.colors),
                  ),

                  // Font & Typography Trigger
                  _buildSubMenuTrigger(
                    icon: Icons.text_format_rounded,
                    label: 'Fonts',
                    isActive: _activeSubMenu == _ToolbarSubMenu.fonts,
                    activeColor: const Color(0xFF6366F1),
                    onTap: () => _toggleSubMenu(_ToolbarSubMenu.fonts),
                  ),

                  _buildDivider(isDark),

                  // Formatting: Bold
                  _buildFormatBtn(
                    label: 'B',
                    tooltip: 'Bold (**text**)',
                    isBold: true,
                    onTap: () => widget.controller.applyFormatting('**', '**'),
                  ),

                  // Formatting: Italic
                  _buildFormatBtn(
                    label: 'I',
                    tooltip: 'Italic (*text*)',
                    isItalic: true,
                    onTap: () => widget.controller.applyFormatting('*', '*'),
                  ),

                  // Formatting: Heading 1
                  _buildFormatBtn(
                    label: 'H1',
                    tooltip: 'Heading 1',
                    onTap: () => widget.controller.insertBlock('# '),
                  ),

                  // Formatting: Heading 2
                  _buildFormatBtn(
                    label: 'H2',
                    tooltip: 'Heading 2',
                    onTap: () => widget.controller.insertBlock('## '),
                  ),

                  _buildDivider(isDark),

                  // Formatting: Checklist
                  _buildFormatIconBtn(
                    icon: Icons.check_box_outlined,
                    tooltip: 'Checklist Item ([ ] )',
                    onTap: () => widget.controller.insertBlock('[ ] '),
                  ),

                  // Formatting: Bullet
                  _buildFormatIconBtn(
                    icon: Icons.format_list_bulleted_rounded,
                    tooltip: 'Bullet Item (• )',
                    onTap: () => widget.controller.insertBlock('• '),
                  ),

                  // Formatting: Numbered
                  _buildFormatIconBtn(
                    icon: Icons.format_list_numbered_rounded,
                    tooltip: 'Numbered Item (1. )',
                    onTap: () => widget.controller.insertBlock('1. '),
                  ),

                  // Formatting: Quote
                  _buildFormatIconBtn(
                    icon: Icons.format_quote_rounded,
                    tooltip: 'Blockquote (> )',
                    onTap: () => widget.controller.insertBlock('> '),
                  ),

                  // Formatting: Code Block
                  _buildFormatIconBtn(
                    icon: Icons.code_rounded,
                    tooltip: 'Code (`code`)',
                    onTap: () => widget.controller.applyFormatting('`', '`'),
                  ),

                  // Formatting: Timestamp
                  _buildFormatIconBtn(
                    icon: Icons.access_time_rounded,
                    tooltip: 'Insert Date/Time Stamp',
                    onTap: widget.controller.insertTimestamp,
                  ),

                  // Formatting: Horizontal Rule
                  _buildFormatIconBtn(
                    icon: Icons.horizontal_rule_rounded,
                    tooltip: 'Divider Rule (---)',
                    onTap: () => widget.controller.insertBlock('---\n'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildSubMenuTrigger({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      child: Material(
        color: isActive ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? activeColor : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: isActive ? activeColor : null),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? activeColor : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatBtn({
    required String label,
    required String tooltip,
    bool isBold = false,
    bool isItalic = false,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatIconBtn({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Icon(icon, size: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuPanel(BuildContext context, bool isDark, Color primaryColor) {
    if (_activeSubMenu == _ToolbarSubMenu.colors) {
      return _buildColorPaletteSubMenu(isDark);
    } else if (_activeSubMenu == _ToolbarSubMenu.fonts) {
      return _buildFontTypographySubMenu(isDark, primaryColor);
    }
    return const SizedBox.shrink();
  }

  Widget _buildColorPaletteSubMenu(bool isDark) {
    return Obx(() {
      final selectedIdx = widget.controller.selectedColorIndex.value;
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131D31) : const Color(0xFFF8FAFC),
          border: Border(
            bottom: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette_rounded, size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                const Text(
                  'Note Color Palette',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  NoteColorPalette.getItem(selectedIdx).name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: NoteColorPalette.getItem(selectedIdx).dotColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: NoteColorPalette.presets.map((item) {
                  final isSelected = selectedIdx == item.id;
                  final bg = isDark ? item.darkBackground : item.lightBackground;
                  final border = item.dotColor;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => widget.controller.setColorIndex(item.id),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? border : border.withValues(alpha: 0.35),
                            width: isSelected ? 2.5 : 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: border.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isSelected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: border,
                                )
                              : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: item.dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFontTypographySubMenu(bool isDark, Color primaryColor) {
    return Obx(() {
      final activeFont = widget.controller.selectedFont.value;
      final currentSize = widget.controller.fontSize.value;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131D31) : const Color(0xFFF8FAFC),
          border: Border(
            bottom: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Font Family Header & Selector
            Row(
              children: [
                const Icon(Icons.text_fields_rounded, size: 14, color: Color(0xFF6366F1)),
                const SizedBox(width: 6),
                const Text(
                  'Typography & Font Style',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                // Font Size Adjuster Controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSizeBtn(
                      label: 'A-',
                      tooltip: 'Decrease font size',
                      onTap: () {
                        if (currentSize > 13.0) {
                          widget.controller.setFontSize(currentSize - 1.0);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '${currentSize.toInt()}px',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    _buildSizeBtn(
                      label: 'A+',
                      tooltip: 'Increase font size',
                      onTap: () {
                        if (currentSize < 24.0) {
                          widget.controller.setFontSize(currentSize + 1.0);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Font Family Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: NoteFontFamily.values.map((font) {
                  final isSelected = activeFont == font;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(
                        font.label,
                        style: font.getTextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
                        ),
                      ),
                      avatar: Icon(
                        font.icon,
                        size: 14,
                        color: isSelected ? Colors.white : primaryColor,
                      ),
                      selectedColor: primaryColor,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onSelected: (_) => widget.controller.setFont(font),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSizeBtn({
    required String label,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF64748B).withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
