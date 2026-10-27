import 'dart:async';
import 'package:flutter/material.dart';

import '../../res/const_color.dart';

class Toast {
  static void show(
      BuildContext context,
      String message, {
        Color backgroundColor = ColorConst.green,
        Duration duration = const Duration(seconds: 3),
      }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _TopSlideToast(
        message: message,
        backgroundColor: backgroundColor,
        duration: duration,
        onFinish: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }
}

class _TopSlideToast extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback onFinish;

  const _TopSlideToast({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.duration,
    required this.onFinish,
  });

  @override
  State<_TopSlideToast> createState() => _TopSlideToastState();
}

class _TopSlideToastState extends State<_TopSlideToast>
    with TickerProviderStateMixin {
  // Existing controllers
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  // ✨ NEW: Icon pulse controller
  late AnimationController _iconPulseController;
  late Animation<double> _iconScale;

  // ✨ NEW: Shimmer sweep controller
  late AnimationController _shimmerController;
  late Animation<double> _shimmerPosition;

  // ✨ NEW: Bounce-out dismiss controller
  late AnimationController _bounceOutController;
  late Animation<double> _bounceOffset;

  bool _closing = false;

  @override
  void initState() {
    super.initState();

    // --- Existing ---
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fade = CurvedAnimation(parent: _slideController, curve: Curves.easeInOut);

    // ✨ NEW: Icon bounces in (scale 0 → 1.2 → 1)
    _iconPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.25), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _iconPulseController, curve: Curves.easeOut));

    // ✨ NEW: Shimmer sweeps across progress bar repeatedly
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _shimmerPosition = Tween<double>(begin: -0.4, end: 1.4)
        .animate(CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));

    // ✨ NEW: Bounce up then fade on dismiss
    _bounceOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 4.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: -20.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _bounceOutController, curve: Curves.easeInOut));

    // Start everything
    _slideController.forward();
    _progressController.forward();

    // Icon pulse triggers after slide-in
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _iconPulseController.forward();
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _reverseAndFinish();
    });
  }

  Future<void> _reverseAndFinish() async {
    if (_closing || !mounted) return;
    setState(() => _closing = true);

    // ✨ NEW: Bounce out before removing
    _shimmerController.stop();
    await _bounceOutController.forward();
    await _slideController.reverse();
    widget.onFinish();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    _iconPulseController.dispose();
    _shimmerController.dispose();
    _bounceOutController.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    if (widget.backgroundColor == Colors.red) return Icons.error;
    if (widget.backgroundColor == Colors.orange) return Icons.warning;
    if (widget.backgroundColor == Colors.blue) return Icons.info;
    return Icons.check_circle;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding + 10, left: 16, right: 16),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              // ✨ NEW: Bounce offset on dismiss
              child: AnimatedBuilder(
                animation: _bounceOutController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceOffset.value),
                    child: child,
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(color: widget.backgroundColor, width: 4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.backgroundColor.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              // ✨ NEW: Icon with pulse scale animation
                              ScaleTransition(
                                scale: _iconScale,
                                child: Icon(
                                  _getIcon(),
                                  color: widget.backgroundColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.message,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _reverseAndFinish,
                                child: Icon(Icons.close, size: 16, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),

                        // ✨ NEW: Progress bar with shimmer overlay
                        AnimatedBuilder(
                          animation: Listenable.merge([_progressController, _shimmerPosition]),
                          builder: (context, child) {
                            return SizedBox(
                              height: 3,
                              child: Stack(
                                children: [
                                  // Base progress bar
                                  LinearProgressIndicator(
                                    value: 1.0 - _progressController.value,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation(
                                      widget.backgroundColor.withOpacity(0.8),
                                    ),
                                  ),
                                  // ✨ Shimmer sweep layer
                                  FractionallySizedBox(
                                    widthFactor: (1.0 - _progressController.value).clamp(0.0, 1.0),
                                    alignment: Alignment.centerLeft,
                                    child: ClipRect(
                                      child: ShaderMask(
                                        shaderCallback: (bounds) {
                                          final pos = _shimmerPosition.value;
                                          return LinearGradient(
                                            begin: Alignment(pos - 0.3, 0),
                                            end: Alignment(pos + 0.3, 0),
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withOpacity(0.55),
                                              Colors.transparent,
                                            ],
                                          ).createShader(bounds);
                                        },
                                        blendMode: BlendMode.srcATop,
                                        child: Container(
                                          color: widget.backgroundColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}