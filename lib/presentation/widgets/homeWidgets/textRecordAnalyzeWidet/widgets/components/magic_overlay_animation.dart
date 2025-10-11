import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/color_manager.dart';

class MagicOverlayAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const MagicOverlayAnimation({
    super.key,
    required this.onComplete,
  });

  @override
  State<MagicOverlayAnimation> createState() => _MagicOverlayAnimationState();
}

class _MagicOverlayAnimationState extends State<MagicOverlayAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<LetterParticle> _letters = [];
  final List<SparkleParticle> _sparkles = [];
  final List<CheckmarkParticle> _checkmarks = [];
  final Random _random = Random();

  final List<String> _letterPool = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );

    // Generate letters falling INTO the brain
    for (int i = 0; i < 18; i++) {
      _letters.add(LetterParticle(
        letter: _letterPool[_random.nextInt(_letterPool.length)],
        startX: 0.25 + _random.nextDouble() * 0.5,
        delay: _random.nextDouble() * 0.35,
        speed: 0.5 + _random.nextDouble() * 0.4,
        rotation: _random.nextDouble() * pi * 2,
      ));
    }

    // Generate sparkles rising FROM the brain (earlier phase)
    for (int i = 0; i < 25; i++) {
      _sparkles.add(SparkleParticle(
        startX: 0.42 + _random.nextDouble() * 0.16,
        delay: 0.25 + _random.nextDouble() * 0.4,
        speed: 0.4 + _random.nextDouble() * 0.6,
        sway: (_random.nextDouble() - 0.5) * 0.12,
        size: 12.0 + _random.nextDouble() * 8.0,
      ));
    }

    // Generate checkmarks rising FROM the brain (later phase - results)
    for (int i = 0; i < 12; i++) {
      _checkmarks.add(CheckmarkParticle(
        startX: 0.4 + _random.nextDouble() * 0.2,
        delay: 0.5 + _random.nextDouble() * 0.3,
        speed: 0.5 + _random.nextDouble() * 0.4,
        sway: (_random.nextDouble() - 0.5) * 0.08,
      ));
    }

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final centerY = screenHeight / 2;

        return Stack(
          children: [
            // Backdrop with smooth fade
            AnimatedOpacity(
              opacity: _controller.value < 0.12
                  ? _controller.value * 8.33
                  : _controller.value > 0.88
                  ? (1 - _controller.value) * 8.33
                  : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                color: Colors.black.withValues(alpha: 0.65),
              ),
            ),

            // Letters falling DOWN into brain
            ..._letters.map((letter) {
              final progress = (_controller.value - letter.delay).clamp(0.0, 1.0);
              if (progress <= 0 || progress > 0.55) return const SizedBox.shrink();

              final easedProgress = _easeInCubic(progress * 1.82);
              final yPosition = centerY * 0.45 + (centerY * 0.35) * easedProgress;
              final opacity = (1.0 - (progress * 1.82)).clamp(0.0, 1.0);
              final scale = 1.0 - (progress * 0.3);

              return Positioned(
                left: letter.startX * screenWidth - 15,
                top: yPosition,
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: letter.rotation + (progress * pi * 1.5),
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                        letter.letter,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.mainGreen,
                          shadows: [
                            Shadow(
                              color: ColorManager.mainGreen.withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Sparkles rising UP from brain (processing phase)
            ..._sparkles.map((sparkle) {
              final progress = (_controller.value - sparkle.delay).clamp(0.0, 1.0);
              if (progress <= 0 || progress > 0.65) return const SizedBox.shrink();

              final easedProgress = _easeOutCubic(progress * 1.54);
              final yPosition = centerY * 0.85 - (centerY * 0.65) * easedProgress;
              final xOffset = sin(progress * pi * 3) * sparkle.sway * screenWidth;
              final opacity = progress < 0.5
                  ? progress * 2
                  : (1 - (progress - 0.5) * 2);

              return Positioned(
                left: sparkle.startX * screenWidth + xOffset - sparkle.size / 2,
                top: yPosition,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.rotate(
                    angle: progress * pi * 6,
                    child: Icon(
                      Icons.auto_awesome,
                      size: sparkle.size,
                      color: ColorManager.mainGreen.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              );
            }),

            // Checkmarks rising UP from brain (results phase)
            ..._checkmarks.map((check) {
              final progress = (_controller.value - check.delay).clamp(0.0, 1.0);
              if (progress <= 0) return const SizedBox.shrink();

              final easedProgress = _easeOutQuad(progress);
              final yPosition = centerY * 0.88 - (centerY * 0.5) * easedProgress;
              final xOffset = sin(progress * pi * 2.5) * check.sway * screenWidth;
              final opacity = progress < 0.7 ? 1.0 : (1 - (progress - 0.7) / 0.3);
              final scale = 0.5 + (min(progress * 2, 1.0) * 0.5);

              return Positioned(
                left: check.startX * screenWidth + xOffset - 12,
                top: yPosition,
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(
                      Icons.check_circle,
                      size: 24.w,
                      color: ColorManager.mainGreen,
                    ),
                  ),
                ),
              );
            }),

            // AI Brain with enhanced effects
            Center(
              child: AnimatedOpacity(
                opacity: _controller.value > 0.15 && _controller.value < 0.85
                    ? 1.0
                    : 0.0,
                duration: const Duration(milliseconds: 350),
                child: Transform.scale(
                  scale: _controller.value < 0.2
                      ? 0.8 + (_controller.value * 1.0)
                      : 1.0,
                  child: Container(
                    padding: EdgeInsets.all(28.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.mainGreen.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Brain icon with pulsing effect
                        Transform.scale(
                          scale: 1.0 + sin(_controller.value * pi * 8) * 0.08,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              color: ColorManager.mainGreen.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.mainGreen.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.psychology,
                              size: 45.w,
                              color: ColorManager.mainGreen,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Progress indicator
                        SizedBox(
                          width: 38.w,
                          height: 38.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.mainGreen,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Analyzing...',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _easeInCubic(double t) => t * t * t;
  num _easeOutCubic(double t) => 1 - pow(1 - t, 3);
  double _easeOutQuad(double t) => t * (2 - t);
}

class LetterParticle {
  final String letter;
  final double startX;
  final double delay;
  final double speed;
  final double rotation;

  LetterParticle({
    required this.letter,
    required this.startX,
    required this.delay,
    required this.speed,
    required this.rotation,
  });
}

class SparkleParticle {
  final double startX;
  final double delay;
  final double speed;
  final double sway;
  final double size;

  SparkleParticle({
    required this.startX,
    required this.delay,
    required this.speed,
    required this.sway,
    required this.size,
  });
}

class CheckmarkParticle {
  final double startX;
  final double delay;
  final double speed;
  final double sway;

  CheckmarkParticle({
    required this.startX,
    required this.delay,
    required this.speed,
    required this.sway,
  });
}