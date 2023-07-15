abstract class SignUpEvent {}

class SignUpFieldsEnteredEvent extends SignUpEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  SignUpFieldsEnteredEvent(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.confirmPassword});
}

class SignUpViewPasswordEvent extends SignUpEvent {
  bool isVisible = false;
  SignUpViewPasswordEvent({required this.isVisible});
}

class SignUpBtnPressedEvent extends SignUpEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  SignUpBtnPressedEvent(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.confirmPassword});
}

class SignUpErrorEvent extends SignUpEvent {
  final String error;
  SignUpErrorEvent({required this.error});
}
