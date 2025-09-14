abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

/// State when toggling between login and signup
class AuthToggleModeState extends AuthStates {}