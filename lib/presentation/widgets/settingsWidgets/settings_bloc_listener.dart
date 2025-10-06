import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sounds_cool/business_logic/settingsCubit/settings_cubit.dart';

import '../../../business_logic/settingsCubit/settings_states.dart';
import '../../../helpers/color_manager.dart';
import '../../../routing/routes.dart';

class SettingsBlocListener extends StatelessWidget {
  const SettingsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsStates>(
      listener: (context, state) {
        if (state is SignOutLoadingState) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(color: ColorManager.mainGreen),
            ),
          );
        } else if (state is SignOutSuccessState) {
          // Close loading dialog
          Navigator.of(context).pop();

          // Navigate to login screen and clear all previous routes
          Navigator.pushReplacementNamed(context, Routes.authScreen);
        }

        if (state is SignOutErrorState) {
          // Close loading dialog if open
          Navigator.of(context).pop();
          // Show error message

        }

        if (state is DeleteAccountLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(color: ColorManager.mainGreen),
            ),
          );
        } else if (state is DeleteAccountSuccessState) {
          Navigator.of(context).pop(); // Close loading
          Navigator.pushReplacementNamed(context, Routes.authScreen);
        } else if (state is DeleteAccountErrorState) {
          Navigator.of(context).pop(); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }

      },
      child: Container(),
    );
  }
}
