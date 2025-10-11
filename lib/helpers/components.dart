

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/cupertino.dart';
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
      child: LoadingAnimationWidget.inkDrop(color: color, size: size ?? 55.sp),
    ),
  );
}

void showSignOutDialog(BuildContext context, {required VoidCallback onConfirm}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Sign Out'),
      content: const Text(
        'Are you sure you want to sign out?',
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel' , style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onConfirm,
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );
}

void showDeleteAccountDialog(BuildContext context, {required VoidCallback onConfirm}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        'Delete Account',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp
        ),
      ),
      content: const Text(
        'This action cannot be undone. All your data will be permanently deleted.',
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

Future<void> showPasswordDialog(
    BuildContext context, {
      required void Function(String password) onConfirm,
    }) async {
  final TextEditingController passwordController = TextEditingController();

  await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        'Confirm Password',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp, // larger title
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: 16.h), // more spacing
        child: SizedBox(
          height: 50.h, // make the field taller
          child: CupertinoTextField(
            controller: passwordController,
            obscureText: true,
            placeholder: 'Enter your password',
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            style: TextStyle(fontSize: 16.sp), // bigger text
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            final password = passwordController.text.trim();
            if (password.isNotEmpty) {
              Navigator.of(context).pop();
              onConfirm(password);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}



class DailyLimitDialog {
  static void show(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            'Great practice today!',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: Text(
          'Come back tomorrow for more, or upgrade for unlimited sessions.',
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe Later',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 15.sp,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              // Show coming soon message
              _showComingSoonSnackbar(context);
            },
            child: Text(
              'Upgrade Now',
              style: TextStyle(
                color: ColorManager.mainBlue,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Premium features coming soon! 🚀',
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          ],
        ),
        backgroundColor: ColorManager.mainBlue,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}


class GenerationLimitDialog {
  static void show(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            '📚 Daily Limit Reached',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: Text(
          'You\'ve generated 10 texts today. Come back tomorrow for more, or stay tuned for premium features!',
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 15.sp,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonSnackbar(context);
            },
            child: Text(
              'Premium (Soon)',
              style: TextStyle(
                color: ColorManager.mainBlue,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Premium features coming soon! 🚀',
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          ],
        ),
        backgroundColor: ColorManager.mainBlue,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
