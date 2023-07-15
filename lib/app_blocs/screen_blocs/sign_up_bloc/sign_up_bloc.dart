import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpFieldsEnteredEvent>((event, emit) => _fieldsEntered(event, emit));
    on<SignUpViewPasswordEvent>((event, emit) => _viewPass(event, emit));
    on<SignUpBtnPressedEvent>((event, emit) => _signUpBtnPressed(event, emit));
    on<SignUpErrorEvent>((event, emit) => _signUpError(event, emit));
  }

  _fieldsEntered(SignUpFieldsEnteredEvent event, Emitter<SignUpState> emit) {
    if (event.name.trim().isNotEmpty &&
        event.email.trim().isNotEmpty &&
        event.phoneNumber.trim().isNotEmpty &&
        event.password.trim().isNotEmpty &&
        event.confirmPassword.trim().isNotEmpty) {
      emit(SignUpValidState());
    } else {
      emit(SignUpInitialState());
    }
  }

  _viewPass(SignUpViewPasswordEvent event, Emitter<SignUpState> emit) {
    if (event.isVisible) {
      emit(SignUpViewPassState(viewPass: false));
    } else {
      emit(SignUpViewPassState(viewPass: true));
    }
  }

  _signUpBtnPressed(
      SignUpBtnPressedEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      //await _fireStore.collection().add(data)
    } on FirebaseAuthException catch (e) {
      add(SignUpErrorEvent(error: e.toString()));
    } catch (e) {
      add(SignUpErrorEvent(error: e.toString()));
    }
  }

  _signUpError(SignUpErrorEvent event, Emitter<SignUpState> emit) {
    emit(SignUpErrorState());
  }
}
