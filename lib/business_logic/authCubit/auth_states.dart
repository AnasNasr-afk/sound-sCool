abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

/// State when toggling between login and signup
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