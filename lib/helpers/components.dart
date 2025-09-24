import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sounds_cool/helpers/text_styles.dart';

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

void showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Sign Out',
          style: TextStyles.font20BlackBold.copyWith(
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyles.font16LightBlackSemiBold.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyles.font16LightBlackSemiBold.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle sign out
            },
            child: Text(
              'Sign Out',
              style: TextStyles.font16LightBlackSemiBold.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Account',
          style: TextStyles.font20BlackBold.copyWith(
            fontSize: 18.sp,
            color: Colors.red,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyles.font16LightBlackSemiBold.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyles.font16LightBlackSemiBold.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle delete account
            },
            child: Text(
              'Delete',
              style: TextStyles.font16LightBlackSemiBold.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}