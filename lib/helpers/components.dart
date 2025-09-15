import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'color_manager.dart';

void showAppLoadingDialog(
    BuildContext context, {
      Color color = ColorManager.mainBlack,
      double? size,
    }) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: LoadingAnimationWidget.inkDrop(
        color: color,
        size: size ?? 55.sp,
      ),
    ),
  );
}