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

