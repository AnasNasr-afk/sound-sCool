import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/text_styles.dart';

class AnalyzeLoading extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration duration;

  const AnalyzeLoading({
    super.key,
    this.onComplete,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnalyzeLoading> createState() => _AnalyzeLoadingState();
}

class _AnalyzeLoadingState extends State<AnalyzeLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _dismissAfterDelay();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation for entrance
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Fade animation for entrance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  void _dismissAfterDelay() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        _exitAnimation();
      }
    });
  }

  Future<void> _exitAnimation() async {
    await _controller.reverse();
    if (mounted) {
      Navigator.pop(context);
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                top: 24.h,
                bottom: 24.h,
                left: 16.w,
                right: 16.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie animation with pulse effect
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
                      ),
                    ),
                    child: SizedBox(
                      width: 200.w,
                      height: 200.h,
                      child: Lottie.asset(
                        'assets/animations/Loading.json',
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Text with fade-in animation
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Analyzing...',
                          textAlign: TextAlign.center,
                          style: TextStyles.font18BlackBold,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Processing your voice',
                          textAlign: TextAlign.center,
                          style: TextStyles.font12GreenMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}