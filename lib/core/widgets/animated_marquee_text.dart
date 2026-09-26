import 'package:flutter/material.dart';

/// Reusable auto-scrolling horizontal marquee text widget.
///
/// If the text exceeds available horizontal space, it smoothly animates from left
/// to right in a continuous loop, ensuring long dates and labels remain 100% visible.
class AnimatedMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration scrollDuration;
  final Duration pauseDuration;

  const AnimatedMarqueeText({
    super.key,
    required this.text,
    this.style,
    this.scrollDuration = const Duration(seconds: 4),
    this.pauseDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<AnimatedMarqueeText> createState() => _AnimatedMarqueeTextState();
}

class _AnimatedMarqueeTextState extends State<AnimatedMarqueeText> {
  late final ScrollController _scrollController;
  bool _isLooping = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarqueeLoop());
  }

  @override
  void didUpdateWidget(covariant AnimatedMarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _startMarqueeLoop());
    }
  }

  void _startMarqueeLoop() async {
    if (!mounted) return;
    if (_isLooping) return;

    await Future.delayed(widget.pauseDuration);
    if (!mounted || !_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    _isLooping = true;
    while (mounted && _isLooping && _scrollController.hasClients) {
      // Animate from Left to Right
      await _scrollController.animateTo(
        maxScroll,
        duration: widget.scrollDuration,
        curve: Curves.easeInOut,
      );

      await Future.delayed(widget.pauseDuration);
      if (!mounted || !_scrollController.hasClients) break;

      // Animate back to Start
      await _scrollController.animateTo(
        0,
        duration: widget.scrollDuration,
        curve: Curves.easeInOut,
      );

      await Future.delayed(widget.pauseDuration);
    }
    _isLooping = false;
  }

  @override
  void dispose() {
    _isLooping = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
