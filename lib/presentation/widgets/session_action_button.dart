import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helpers/color_manager.dart';

enum ActionState { idle, mic, recording }

class SessionActionButton extends StatelessWidget {
  final ActionState actionState;
  final VoidCallback onGenerate;
  final VoidCallback onMic;
  final VoidCallback onStop;

  const SessionActionButton({
    super.key,
    required this.actionState,
    required this.onGenerate,
    required this.onMic,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color backgroundColor;
    VoidCallback onPressed;

    switch (actionState) {
      case ActionState.idle:
        icon = Icons.generating_tokens_rounded;
        backgroundColor = ColorManager.mainGreen;
        onPressed = onGenerate;
        break;

      case ActionState.mic:
        icon = Icons.mic;
        backgroundColor = ColorManager.mainGreen;
        onPressed = onMic;
        break;

      case ActionState.recording:
        icon = Icons.stop;
        backgroundColor = ColorManager.isRecordingColor;
        onPressed = onStop;
        break;
    }

    return Container(
      width: 65.w,
      height: 65.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
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
        onPressed: onPressed,
        icon: Icon(icon, size: 32.w, color: Colors.white),
        splashRadius: 30.r,
      ),
    );
  }
}
