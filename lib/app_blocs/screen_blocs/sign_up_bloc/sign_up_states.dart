abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpValidState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpErrorState extends SignUpState {
  final String error;
  SignUpErrorState({required this.error});
}
