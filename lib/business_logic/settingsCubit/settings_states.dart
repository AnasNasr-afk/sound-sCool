abstract class SettingsStates {}
class SettingsInitialState extends SettingsStates {}

class SignOutLoadingState extends SettingsStates {}
class SignOutSuccessState extends SettingsStates {}
class SignOutErrorState extends SettingsStates {
  final String error;
  SignOutErrorState(this.error);
}

class DeleteAccountLoadingState extends SettingsStates {}
class DeleteAccountSuccessState extends SettingsStates {}
class DeleteAccountErrorState extends SettingsStates {
  final String error;
  DeleteAccountErrorState(this.error);
}
