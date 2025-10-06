import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/shared_pref_helper.dart';
import 'settings_states.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  SettingsCubit() : super(SettingsInitialState());

  static SettingsCubit get(context) => BlocProvider.of(context);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign out user
  Future<void> signOut() async {
    emit(SignOutLoadingState());

    try {
      await _auth.signOut();
      await SharedPrefHelper.removeData("uid");

      emit(SignOutSuccessState());
      debugPrint("✅ User signed out successfully");
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ FirebaseAuthException during sign out: ${e.message}");
      emit(SignOutErrorState(e.message ?? "Sign out failed"));
    } catch (e) {
      debugPrint("❌ Unexpected error during sign out: $e");
      emit(SignOutErrorState("Something went wrong"));
    }
  }

  /// Delete account after reauthentication
  Future<void> deleteAccount(String password) async {
    emit(DeleteAccountLoadingState());

    try {
      User? user = _auth.currentUser;

      if (user == null) {
        emit(DeleteAccountErrorState("No user is currently signed in"));
        return;
      }

      // Default: reauthenticate with Email/Password
      if (user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
      }

      // Delete user
      await user.delete();

      // Clear stored UID
      await SharedPrefHelper.removeData("uid");

      emit(DeleteAccountSuccessState());
      debugPrint("✅ Account deleted successfully!");
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ FirebaseAuthException during delete account: ${e.message}");
      emit(DeleteAccountErrorState(e.message ?? "Delete account failed"));
    } catch (e) {
      debugPrint("❌ Unexpected error during delete account: $e");
      emit(DeleteAccountErrorState("Something went wrong"));
    }
  }


}
