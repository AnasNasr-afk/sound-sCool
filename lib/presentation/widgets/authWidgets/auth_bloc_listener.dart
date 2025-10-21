// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../business_logic/authCubit/auth_cubit.dart';
// import '../../../business_logic/authCubit/auth_states.dart';
// import '../../../routing/routes.dart';
//
// class AuthBlocListener extends StatelessWidget {
//   const AuthBlocListener({super.key});
//
//   // Map Firebase errors to user-friendly messages
//   String _getUserFriendlyErrorMessage(String error) {
//     final errorLower = error.toLowerCase();
//
//     // Firebase Auth errors
//     if (errorLower.contains('user-not-found') || errorLower.contains('wrong-password')) {
//       return 'Incorrect email or password. Please try again.';
//     }
//     if (errorLower.contains('email-already-in-use')) {
//       return 'This email is already registered. Try logging in instead.';
//     }
//     if (errorLower.contains('weak-password')) {
//       return 'Password is too weak. Please use at least 6 characters.';
//     }
//     if (errorLower.contains('invalid-email')) {
//       return 'Please enter a valid email address.';
//     }
//     if (errorLower.contains('too-many-requests')) {
//       return 'Too many attempts. Please try again later.';
//     }
//     if (errorLower.contains('network-request-failed') || errorLower.contains('network')) {
//       return 'Network error. Please check your internet connection.';
//     }
//     if (errorLower.contains('user-disabled')) {
//       return 'This account has been disabled. Please contact support.';
//     }
//     if (errorLower.contains('operation-not-allowed')) {
//       return 'This sign-in method is not enabled. Please contact support.';
//     }
//
//     // Firebase/Firestore permission errors
//     if (errorLower.contains('permission-denied') || errorLower.contains('insufficient permissions')) {
//       return 'Unable to access your account. Please try again or contact support.';
//     }
//
//     // Generic errors
//     if (errorLower.contains('timeout')) {
//       return 'Request timed out. Please try again.';
//     }
//
//     // Default fallback message
//     return 'Something went wrong. Please try again later.';
//   }
//
//   void _showErrorSnackBar(BuildContext context, String error) {
//     final friendlyMessage = _getUserFriendlyErrorMessage(error);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           friendlyMessage,
//           style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//         ),
//         backgroundColor: Colors.redAccent,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(16.w),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12.r)),
//         ),
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthStates>(
//       listener: (context, state) {
//         if (state is LoginSuccessState) {
//           Navigator.pushReplacementNamed(context, Routes.homeScreen);
//         }
//         else if (state is LoginErrorState) {
//           _showErrorSnackBar(context, state.error);
//         }
//         else if (state is SignupSuccessState) {
//           Navigator.pushReplacementNamed(context, Routes.homeScreen);
//         }
//         else if (state is SignupErrorState) {
//           _showErrorSnackBar(context, state.error);
//         }
//         else if (state is GoogleSignInSuccessState) {
//           Navigator.pushReplacementNamed(context, Routes.homeScreen);
//         }
//         else if (state is GoogleSignInErrorState) {
//           _showErrorSnackBar(context, state.error);
//         }
//       },
//       child: const SizedBox(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/authCubit/auth_cubit.dart';
import '../../../business_logic/authCubit/auth_states.dart';
import '../../../routing/routes.dart';
import 'auth_error_handler.dart';

class AuthBlocListener extends StatelessWidget {
  const AuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        // Login Success
        if (state is LoginSuccessState) {
          // AuthErrorHandler.showSuccessSnackBar(context, 'Login successful!');
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        }
        // Login Error
        else if (state is LoginErrorState) {
          AuthErrorHandler.showErrorSnackBar(context, state.error);
        }
        // Signup Success
        else if (state is SignupSuccessState) {
          // AuthErrorHandler.showSuccessSnackBar(context, 'Account created successfully!');
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        }
        // Signup Error
        else if (state is SignupErrorState) {
          AuthErrorHandler.showErrorSnackBar(context, state.error);
        }
        // Google Sign-In Success
        else if (state is GoogleSignInSuccessState) {
          // AuthErrorHandler.showSuccessSnackBar(context, 'Signed in with Google!');
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        }
        // Google Sign-In Error
        else if (state is GoogleSignInErrorState) {
          AuthErrorHandler.showErrorSnackBar(context, state.error);
        }
      },
      child: const SizedBox(),
    );
  }
}