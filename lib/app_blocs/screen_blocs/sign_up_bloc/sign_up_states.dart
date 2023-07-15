abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpValidState extends SignUpState {}

class SignUpFieldsEnteredState extends SignUpState {}

class SignUpViewPassState extends SignUpState {
  final bool viewPass;
  SignUpViewPassState({required this.viewPass});
}

class SignUpLoadingState extends SignUpState {}

class SignUpErrorState extends SignUpState {}
