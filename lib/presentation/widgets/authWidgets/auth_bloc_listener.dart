
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