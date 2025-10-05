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
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particlesController;
  final List<MagicParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Particles animation controller
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..repeat();

    // Generate particles
    for (int i = 0; i < 30; i++) {
      _particles.add(MagicParticle(
        startX: _random.nextDouble(),
        delay: _random.nextDouble() * 0.5,
        speed: 0.8 + _random.nextDouble() * 0.4,
        size: 4.0 + _random.nextDouble() * 8.0,
        color: _getRandomColor(),
      ));
    }

    _mainController.forward();
    _particlesController.addListener(_updateParticles);

    // Complete after animation
    Future.delayed(const Duration(milliseconds: 2500), () {
      widget.onComplete();
    });
  }

  Color _getRandomColor() {
    final colors = [
      ColorManager.mainGreen,
      ColorManager.mainGreen.withValues(alpha: 0.7),
      Colors.white,
      const Color(0xFF4CAF50),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _updateParticles() {
    if (mounted) {
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Stack(
          children: [
            // Semi-transparent backdrop
            AnimatedOpacity(
              opacity: _mainController.value < 0.2
                  ? _mainController.value * 5
                  : _mainController.value > 0.8
                  ? (1 - _mainController.value) * 5
                  : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),

            // Magic particles
            ..._particles.map((particle) {
              final progress = (_mainController.value - particle.delay).clamp(0.0, 1.0);
              if (progress <= 0) return const SizedBox.shrink();

              return Positioned(
                left: particle.currentX * MediaQuery.of(context).size.width,
                top: particle.currentY * MediaQuery.of(context).size.height,
                child: Transform.rotate(
                  angle: particle.rotation,
                  child: AnimatedOpacity(
                    opacity: progress < 0.9 ? 1.0 : (1 - (progress - 0.9) * 10),
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: particle.color,
                        boxShadow: [
                          BoxShadow(
                            color: particle.color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

            // Center magic burst
            Center(
              child: Transform.scale(
                scale: _mainController.value < 0.3
                    ? _mainController.value * 3.33
                    : 1.0,
                child: AnimatedOpacity(
                  opacity: _mainController.value < 0.8
                      ? 1.0
                      : (1 - (_mainController.value - 0.8) * 5),
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          ColorManager.mainGreen.withValues(alpha: 0.6),
                          ColorManager.mainGreen.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 60.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // "Analyzing" text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 200.h),
                  AnimatedOpacity(
                    opacity: _mainController.value > 0.3 && _mainController.value < 0.8
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      'Analyzing...',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: ColorManager.mainGreen,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MagicParticle {
  final double startX;
  final double delay;
  final double speed;
  final double size;
  final Color color;

  double currentX;
  double currentY = 0;
  double velocityX;
  double rotation = 0;

  MagicParticle({
    required this.startX,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
  })  : currentX = startX,
        velocityX = (Random().nextDouble() - 0.5) * 0.002;

  void update() {
    currentY += 0.01 * speed;
    currentX += velocityX;
    rotation += 0.1;

    // Wrap around
    if (currentX < 0) currentX = 1;
    if (currentX > 1) currentX = 0;
    if (currentY > 1) currentY = 0;
  }
}