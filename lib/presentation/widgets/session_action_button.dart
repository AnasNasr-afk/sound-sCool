import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/color_manager.dart';

class SessionActionButton extends StatelessWidget {
  final bool isRecordingAvailable;
  final VoidCallback onGenerate;
  final VoidCallback onRecord;

  const SessionActionButton({
    super.key,
    required this.isRecordingAvailable,
    required this.onGenerate,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isRecordingAvailable
        ? Icons.mic
        : Icons.generating_tokens_rounded;

    return Center(
      child: Container(
        width: 55.w,
        height: 55.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ColorManager.mainGreen,
              ColorManager.mainGreen.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.mainGreen.withValues(alpha: 0.3),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: IconButton(
          onPressed: isRecordingAvailable ? onRecord : onGenerate,
          icon: Icon(icon, size: 32.w, color: Colors.white),
          splashRadius: 40.r,
        ),
      ),
    );
  }
}
