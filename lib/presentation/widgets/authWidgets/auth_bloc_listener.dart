import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/authCubit/auth_cubit.dart';
import '../../../business_logic/authCubit/auth_states.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/components.dart';
import '../../../routing/routes.dart';

class AuthBlocListener extends StatelessWidget {
  const AuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SignupLoadingState) {
          showAppLoadingDialog(context);
        } else if (state is SignupSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is SignupErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Failed: ${state.error}')),
          );
        } else if (state is LoginLoadingState) {
          showAppLoadingDialog(context);
        } else if (state is LoginSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Failed: ${state.error}')),
          );
        }
      //   else if (state is SignOutLoadingState) {
      //     // Show loading indicator
      //     showDialog(
      //       context: context,
      //       barrierDismissible: false,
      //       builder: (context) => Center(
      //         child: CircularProgressIndicator(color: ColorManager.mainGreen),
      //       ),
      //     );
      //   } else if (state is SignOutSuccessState) {
      //     // Close loading dialog
      //     Navigator.of(context).pop();
      //
      //     // Navigate to login screen and clear all previous routes
      //     Navigator.pushNamedAndRemoveUntil(
      //       context,
      //       Routes.authScreen,
      //       (route) => false,
      //     );
      //   }
      //
      //   if (state is SignOutErrorState) {
      //     // Close loading dialog if open
      //     Navigator.of(context).pop();
      //
      //     // Show error message
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text(state.error), backgroundColor: Colors.red),
      //     );
      //   }
      // },
      },
      child: Container(),
    );
  }
}
