import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../helpers/color_manager.dart';

class StageIndicatorRow extends StatelessWidget {
  final Stage currentStage;

  const StageIndicatorRow({super.key, required this.currentStage});

  Widget _buildIndicator({
    required String label,
    required IconData icon,
    required bool active,
    required bool current,
  }) {
    final Color activeColor = ColorManager.mainGreen; // strong accent
    final Color activeFill = ColorManager.mainGreen.withValues(alpha: 0.12); // soft fill
    final Color inactiveFill = ColorManager.mainGrey.withValues(alpha: 0.18);
    final Color inactiveIcon = ColorManager.darkGrey.withValues(alpha: 0.9);
    final double size = 36.w;

    return Column(
      children: [
        // Stack lets us show a subtle halo if current
        Stack(
          alignment: Alignment.center,
          children: [
            if (current)
              Container(
                width: size + 8.w,
                height: size + 8.w,
                decoration: BoxDecoration(
                  color: activeFill,
                  shape: BoxShape.circle,
                ),
              ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? activeColor : inactiveFill,
                border: current
                    ? Border.all(color: activeColor, width: 1.6.w)
                    : null,
              ),
              child: Icon(
                icon,
                size: 16.sp,
                color: active ? Colors.white : inactiveIcon,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? activeColor : ColorManager.darkGrey,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool active) {
    return Expanded(
      child: Divider(
        thickness: 1,
        color: active
            ? ColorManager.mainGreen.withValues(alpha: 0.85)
            : ColorManager.mainGrey.withValues(alpha: 0.18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIndicator(
          label: "Generate",
          icon: Icons.auto_awesome,
          active: currentStage.index >= Stage.generate.index,
          current: currentStage == Stage.generate,
        ),
        _buildDivider(currentStage.index >= Stage.record.index),
        _buildIndicator(
          label: "Record",
          icon: Icons.mic,
          active: currentStage.index >= Stage.record.index,
          current: currentStage == Stage.record,
        ),
        _buildDivider(currentStage.index >= Stage.analyze.index),
        _buildIndicator(
          label: "Analyze",
          icon: Icons.analytics,
          active: currentStage.index >= Stage.analyze.index,
          current: currentStage == Stage.analyze,
        ),
      ],
    );
  }
}
