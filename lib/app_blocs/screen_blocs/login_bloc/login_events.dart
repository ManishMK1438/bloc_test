abstract class LoginEvent {}

class LoginFieldsEnteredEvent extends LoginEvent {
  String email;
  String password;
  LoginFieldsEnteredEvent({required this.email, required this.password});
}

class LoginBtnPressedEvent extends LoginEvent {
  String email;
  String password;
  LoginBtnPressedEvent({required this.email, required this.password});
}

class LoginErrorEvent extends LoginEvent {
  String error;
  LoginErrorEvent({required this.error});
}
