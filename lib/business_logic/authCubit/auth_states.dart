abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthToggleModeState extends AuthStates {}

class SignupLoadingState extends AuthStates {}
class SignupSuccessState extends AuthStates {}
class SignupErrorState extends AuthStates {
  final String error;
  SignupErrorState(this.error);
}

class LoginLoadingState extends AuthStates {}
class LoginSuccessState extends AuthStates {}
class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState(this.error);
}

class GoogleSignInLoadingState extends AuthStates {}
class GoogleSignInSuccessState extends AuthStates {}
class GoogleSignInErrorState extends AuthStates {
  final String error;
  GoogleSignInErrorState(this.error);
}


