

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
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
  static void show(BuildContext context,
      {int currentCount = 7, int maxCount = 7}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                'Daily Limit Reached',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You\'ve generated $currentCount/$maxCount texts today.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Come back tomorrow for more, or get notified when Premium launches!',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                SizedBox(height: 12.h),
                // Reset time indicator
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        size: 14.w,
                        color: CupertinoColors.systemGrey,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Resets at 12:00 AM',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                onPressed: () async {
                  Navigator.pop(context);
                  await _handleNotifyMeClick(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Notify Me',
                      style: TextStyle(
                        color: ColorManager.mainBlue,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  static Future<void> _handleNotifyMeClick(BuildContext context) async {
    // Check notification permission status
    final status = await Permission.notification.status;

    if (status.isGranted) {
      // Permission already granted - proceed with notification signup
      _showPremiumInterestSnackbar(context);
      // TODO: Track interest in Firestore
      // _trackPremiumInterest(context);
    } else if (status.isDenied) {
      // Permission denied - request it
      final result = await Permission.notification.request();

      if (result.isGranted) {
        _showPremiumInterestSnackbar(context);
        // TODO: Track interest in Firestore
        // _trackPremiumInterest(context);
      } else if (result.isPermanentlyDenied) {
        // User permanently denied - show settings dialog
        _showPermissionDeniedDialog(context);
      } else {
        // User declined this time
        _showPermissionDeclinedSnackbar(context);
      }
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied - direct to settings
      _showPermissionDeniedDialog(context);
    }
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Text(
              '🔔 Enable Notifications',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'To notify you when Premium launches, please enable notifications in Settings.',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Not Now',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: Text(
                  'Open Settings',
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

  static void _showPermissionDeclinedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'You can enable notifications later in Settings',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
        backgroundColor: CupertinoColors.systemGrey,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  static void _showPremiumInterestSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 18.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You\'re on the list! 🎉',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'We\'ll notify you when Premium launches',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: ColorManager.mainBlue,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );

    // TODO: Actually track this interest in Firestore
    // _trackPremiumInterest(context);
  }
}
