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
    return Column(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? ColorManager.mainGreen
                : ColorManager.mainGrey.withValues(alpha: 0.3),
            border: current
                ? Border.all(color: ColorManager.mainGreen, width: 2)
                : null,
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: active ? Colors.white : ColorManager.darkGrey,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: active ? ColorManager.mainGreen : ColorManager.darkGrey,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
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
            ? ColorManager.mainGreen
            : ColorManager.mainGrey.withValues(alpha: 0.3),
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
