import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/color_manager.dart';

class AnalyzingAnimation extends StatefulWidget {
  const AnalyzingAnimation({super.key});

  @override
  State<AnalyzingAnimation> createState() => _AnalyzingAnimationState();
}

class _AnalyzingAnimationState extends State<AnalyzingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _dropController;
  late AnimationController _shimmerController;
  late Animation<double> _dropAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Drop animation
    _dropController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dropAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _dropController,
        curve: Curves.easeOutCubic,
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _dropController,
        curve: const Interval(0.7, 1.0, curve: Curves.bounceOut),
      ),
    );

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );

    _dropController.forward();
  }

  @override
  void dispose() {
    _dropController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _dropController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _dropAnimation.value + _bounceAnimation.value),
                child: AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.mainGreen.withValues(alpha: 0.3),
                                blurRadius: 40.r,
                                spreadRadius: 10.r,
                              ),
                            ],
                          ),
                        ),
                        // Main glass container
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorManager.mainGreen.withValues(alpha: 0.3),
                                ColorManager.mainGreen.withValues(alpha: 0.1),
                              ],
                            ),
                            border: Border.all(
                              color: ColorManager.mainGreen.withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Shimmer effect
                              Positioned(
                                left: _shimmerAnimation.value * 100.w,
                                child: Container(
                                  width: 30.w,
                                  height: 100.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0),
                                        Colors.white.withValues(alpha: 0.3),
                                        Colors.white.withValues(alpha: 0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Icon
                              Center(
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 40.w,
                                  color: ColorManager.mainGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            'Analyzing your pronunciation...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.mainBlack,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 200.w,
            child: LinearProgressIndicator(
              backgroundColor: ColorManager.mainGrey.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(ColorManager.mainGreen),
            ),
          ),
        ],
      ),
    );
  }
}