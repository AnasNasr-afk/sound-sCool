import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthErrorHandler {
  static String getUserFriendlyErrorMessage(String error) {
    final errorLower = error.toLowerCase();

    if (errorLower.contains('user-not-found') || errorLower.contains('wrong-password')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (errorLower.contains('email-already-in-use')) {
      return 'This email is already registered. Try logging in instead.';
    }
    if (errorLower.contains('weak-password')) {
      return 'Password is too weak. Please use at least 6 characters.';
    }
    if (errorLower.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }
    if (errorLower.contains('invalid-password')) {
      return 'Please enter a valid password.';
    }
    if (errorLower.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    }
    if (errorLower.contains('network-request-failed') || errorLower.contains('network')) {
      return 'Network error. Please check your internet connection.';
    }
    if (errorLower.contains('user-disabled')) {
      return 'This account has been disabled. Please contact support.';
    }
    if (errorLower.contains('operation-not-allowed')) {
      return 'This sign-in method is not enabled. Please contact support.';
    }
    if (errorLower.contains('permission-denied') || errorLower.contains('insufficient permissions')) {
      return 'Unable to access your account. Please try again or contact support.';
    }
    if (errorLower.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    return 'Something went wrong. Please try again later.';
  }

  static void showErrorSnackBar(BuildContext context, String error) {
    final friendlyMessage = getUserFriendlyErrorMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          friendlyMessage,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}